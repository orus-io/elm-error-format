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
    , escapeNext : Bool
    }


init : Options -> Formater
init options =
    { options = options
    , inString = False
    , escapeNext = False
    }



-- Parse


openContext : Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
openContext c ( formater, writer ) =
    ( formater
    , writer
        |> Writer.appendToBuffer c
        >> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.indent
    )


closeContext : Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeContext c ( formater, writer ) =
    ( formater
    , writer
        |> Writer.flushBufferAsText
        >> Writer.flushCurrentLine
        >> Writer.writeText (String.fromChar c)
        >> Writer.unindent
    )


parseChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.inString, c ) of
        ( False, Reader.LBrace ) ->
            ( formater, writer ) |> openContext '{'

        ( False, Reader.RBrace ) ->
            ( formater, writer ) |> closeContext '}'

        ( False, Reader.LBracket ) ->
            ( formater, writer ) |> openContext '['

        ( False, Reader.RBracket ) ->
            ( formater, writer ) |> closeContext ']'

        ( False, Reader.Comma ) ->
            ( formater
            , writer
                |> Writer.appendToBuffer ','
                >> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
                >> Writer.flushCurrentLine
            )

        ( False, Reader.Escaped '"' ) ->
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
            let
                _ =
                    Debug.log "!!!" Reader.DoubleQuote
            in
                ( { formater
                    | inString = False
                  }
                , writer
                    |> Writer.appendToBuffer '"'
                    |> Writer.flushBufferAsColoredText
                        formater.options.stringColor
                )

        ( _, c ) ->
            ( { formater
                | escapeNext = False
              }
            , writer
                |> Writer.appendToBuffer (Reader.toChar c)
            )


parseEOF : ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseEOF ( formater, writer ) =
    ( formater
    , writer
        |> Writer.flushBufferAsText
    )
