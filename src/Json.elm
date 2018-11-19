module Json exposing (..)

import Writer exposing (Writer)
import Reader
    exposing
        ( Reader
        , InputChar
        , toChar
        )


-- Json Formater


type alias Options =
    { stringColor : String }


defaultOptions : Options
defaultOptions =
    { stringColor = "orangered" }


type alias Formater =
    { options : Options
    , contextStack : List ComplexType
    , inString : Bool
    }


init : Options -> Formater
init options =
    { options = options
    , contextStack = []
    , inString = False
    }


type ComplexType
    = List
    | Record


pushContext : ComplexType -> Formater -> Formater
pushContext t f =
    { f
        | contextStack = t :: f.contextStack
    }


popContext : Formater -> Formater
popContext f =
    { f | contextStack = List.drop 1 f.contextStack }



-- Parse


openContext : ComplexType -> InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
openContext t c ( formater, writer ) =
    ( formater
        |> pushContext t
    , writer
        |> Writer.appendToBuffer (toChar c)
        >> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
    )


closeContext : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeContext c ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar <| toChar c)
        >> Writer.unindent
    )


parseChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.inString, c ) of
        ( False, Reader.LBrace ) ->
            ( formater, writer ) |> openContext Record Reader.LBrace

        ( False, Reader.RBrace ) ->
            ( formater, writer ) |> closeContext Reader.RBrace

        ( False, Reader.LBracket ) ->
            ( formater, writer ) |> openContext List Reader.LBracket

        ( False, Reader.RBracket ) ->
            ( formater, writer ) |> closeContext Reader.RBracket

        ( False, Reader.Comma ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer ','
                >> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
                >> Writer.flushCurrentLine
            )

        ( False, Reader.Escaped '"' ) ->
            {- Enter Json inString -}
            ( { formater
                | inString = True
              }
            , writer
                |> Writer.flushBufferAsText
                |> Writer.appendToBuffer '"'
            )

        ( True, Reader.Escaped '"' ) ->
            {- Exit Json inString -}
            ( { formater
                | inString = False
              }
            , writer
                |> Writer.appendToBuffer '"'
                |> Writer.flushBufferAsColoredText
                    formater.options.stringColor
            )

        ( True, Reader.Escaped c ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer '\\'
                |> Writer.appendToBuffer (Reader.toChar <| Reader.Escaped c)
            )

        ( _, c ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer (Reader.toChar c)
            )


parseEOF : ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseEOF ( formater, writer ) =
    ( formater
    , writer
        |> Writer.flushBufferAsText
    )
