module Json exposing (..)

import Writer exposing (Writer)


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


parseChar : Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.inString, c ) of
        ( _, '\\' ) ->
            ( { formater
                | escapeNext = not formater.escapeNext
              }
            , writer
                |> Writer.appendToBuffer '\\'
            )

        ( False, '{' ) ->
            ( formater, writer ) |> openContext '{'

        ( False, '}' ) ->
            ( formater, writer ) |> closeContext '}'

        ( False, '[' ) ->
            ( formater, writer ) |> openContext '['

        ( False, ']' ) ->
            ( formater, writer ) |> closeContext ']'

        ( False, ',' ) ->
            ( { formater
                | escapeNext = False
              }
            , writer
                |> Writer.appendToBuffer ','
                >> Writer.flushBufferAsText
                >> Writer.flushCurrentLine
                >> Writer.flushCurrentLine
            )

        ( False, '"' ) ->
            ( { formater
                | inString = True
              }
            , writer
                |> Writer.appendToBuffer '"'
            )

        ( True, '"' ) ->
            if formater.escapeNext then
                ( { formater
                    | escapeNext = False
                  }
                , writer
                    |> Writer.appendToBuffer '"'
                )
            else
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
                |> Writer.appendToBuffer c
            )


parseEOF : ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseEOF ( formater, writer ) =
    ( formater
    , writer
        |> Writer.flushBufferAsText
    )
