module Error exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (style, class)
import Formater
import Reader
import Writer


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

            {- Dark mode
               , ( "background", "black" )
               , ( "color", "grey" )
            -}
            ]
        , class "error"
        ]
        [ formatErrString model ]


formatErrString : String -> Html msg
formatErrString error =
    String.foldl
        Formater.read
        ( Reader.new
        , ( Formater.new Formater.defaultOptions
          , Writer.init
          )
        )
        error
        |> Formater.eof
        |> Tuple.second
        |> Tuple.second
        |> Writer.render
