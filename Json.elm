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
    , inString : Bool
    }


init : Options -> Formater
init options =
    { options = options
    , inString = False
    }



-- Parse


openContext : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
openContext v ( formater, writer ) =
    ( formater
    , writer
        |> Writer.appendToBuffer (toChar v)
        >> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
    )


closeContext : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeContext v ( formater, writer ) =
    ( formater
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar <| toChar v)
        >> Writer.unindent
    )


parseChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.inString, c ) of
        ( False, Reader.LBrace ) ->
            ( formater, writer ) |> openContext Reader.LBrace

        ( False, Reader.RBrace ) ->
            ( formater, writer ) |> closeContext Reader.RBrace

        ( False, Reader.LBracket ) ->
            ( formater, writer ) |> openContext Reader.LBracket

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
                |> Writer.appendToBuffer '"'
            )

        ( True, Reader.DoubleQuote ) ->
            ( formater
            , writer
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
