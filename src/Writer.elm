module Writer exposing (..)

import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style)
import Buffer exposing (Buffer)


-- Writer


type alias Writer msg =
    { buffer : Buffer
    , ignoreNextSpace : Bool
    , currentLine : List (Html msg)
    , indent : Int
    , output : List (Html msg)
    }


init : Writer msg
init =
    { buffer = Buffer.empty
    , ignoreNextSpace = False
    , currentLine = []
    , indent = 0
    , output = []
    }


popBuffer : Writer msg -> ( String, Writer msg )
popBuffer w =
    ( w.buffer |> Buffer.toString
    , { w | buffer = Buffer.empty }
    )


dropBuffer : Int -> Writer msg -> Writer msg
dropBuffer n w =
    { w | buffer = Buffer.drop n w.buffer }


appendToBuffer : Char -> Writer msg -> Writer msg
appendToBuffer c w =
    case ( w.ignoreNextSpace, c ) of
        ( True, ' ' ) ->
            w

        ( _, _ ) ->
            { w
                | buffer = Buffer.append c w.buffer
                , ignoreNextSpace = False
            }


appendSingleSpace : Writer msg -> Writer msg
appendSingleSpace w =
    { w
        | ignoreNextSpace = True
        , buffer =
            w.buffer
                |> Buffer.rstrip ' '
                |> Buffer.append ' '
    }


writeText : String -> Writer msg -> Writer msg
writeText s w =
    if String.isEmpty s then
        w
    else
        { w
            | currentLine = List.append w.currentLine [ text s ]
        }


writeColoredText : String -> String -> Writer msg -> Writer msg
writeColoredText color s w =
    { w
        | currentLine =
            List.append
                w.currentLine
                [ span [ style [ ( "color", color ) ] ] [ text s ] ]
    }


flushBufferAsText : Writer msg -> Writer msg
flushBufferAsText w =
    let
        ( s, newW ) =
            popBuffer w
    in
        newW |> writeText s


flushBufferAsColoredText : String -> Writer msg -> Writer msg
flushBufferAsColoredText color w =
    let
        ( s, newW ) =
            popBuffer w
    in
        newW |> writeColoredText color s


indent : Writer msg -> Writer msg
indent w =
    { w
        | indent = w.indent + 1
    }


unindent : Writer msg -> Writer msg
unindent w =
    { w
        | indent = w.indent - 1
    }


padding : Int -> Attribute msg
padding indent =
    style [ ( "padding-left", toString indent ++ "rem" ) ]


flushCurrentLine : Writer msg -> Writer msg
flushCurrentLine w =
    if List.isEmpty w.currentLine then
        w
    else
        { w
            | output =
                List.append w.output
                    [ div [ padding w.indent ] w.currentLine ]
            , currentLine = []
        }


render : Writer msg -> Html msg
render w =
    div [] w.output
