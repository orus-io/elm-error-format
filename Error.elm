module Error exposing (..)

import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style)
import Writer exposing (Writer)
import Formater exposing (Formater)


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
        Formater.parseChar
        ( Formater.newFormater Formater.formaterDefaultOptions, Writer.init )
        error
        |> Formater.parseEOF
        |> Tuple.second
        |> Writer.render
