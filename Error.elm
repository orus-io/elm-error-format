module Error exposing (..)

import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style)
import Formater exposing (Formater)
import Writer exposing (Writer)


type alias Model =
    String


new : String -> Model
new s =
    s



-- VIEW


view : Model -> Html msg
view model =
    div
        [ style
            [ ( "font-family", "monospace" )
            , ( "font-size", "0.8rem" )
            ]
        ]
        [ formatErrString model ]


formatErrString : String -> Html msg
formatErrString error =
    String.foldl
        Formater.read
        ( Formater.newReader
        , ( Formater.new Formater.defaultOptions, Writer.init )
        )
        error
        |> Formater.parseEOF
        |> Tuple.second
        |> Tuple.second
        |> Writer.render
