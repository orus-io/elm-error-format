module Tests exposing (..)

import Expect
import Error
import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style)
import Test exposing (..)


elmColor : String
elmColor =
    "teal"


jsColor : String
jsColor =
    "orangered"


all : Test
all =
    describe "Error"
        [ test "Should format elm struct" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A { B = { C = ( 1, 2 ), D = [ 1, 2 ] } }")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ] [ text "A " ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ] [ text "{ B = " ]
                        , div [ style [ ( "padding-left", "2rem" ) ] ] [ text "{ C = ( 1, 2 )" ]
                        , div [ style [ ( "padding-left", "2rem" ) ] ] [ text ", D = " ]
                        , div [ style [ ( "padding-left", "3rem" ) ] ] [ text "[ 1" ]
                        , div [ style [ ( "padding-left", "3rem" ) ] ] [ text ", 2 " ]
                        , div [ style [ ( "padding-left", "3rem" ) ] ] [ text "]" ]
                        , div [ style [ ( "padding-left", "2rem" ) ] ] [ text " " ]
                        , div [ style [ ( "padding-left", "2rem" ) ] ] [ text "}" ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ] [ text " " ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ] [ text "}" ]
                        ]
                    )
        , test "Should format string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"Elm Rox!\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"Elm Rox!\"" ]
                            ]
                        ]
                    )
        , test "Should format empty string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"\" { B = 1 }")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"\"" ]
                            , text " "
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ] [ text "{ B = 1 " ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ] [ text "}" ]
                        ]
                    )
        , test "Should preserve escaped char in string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"\\n two \\n newline\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"\\n two \\n newline\"" ]
                            ]
                        ]
                    )
        , test "Should format string with escaped char" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"Elm Rox!\\\n \\\"More than you expect\\\"\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"Elm Rox!\\\n \\\"More than you expect\\\"\"" ]
                            ]
                        ]
                    )
        , test "Should format Json string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"{\\\"answer\\\": 42}\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            , text "{"
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ]
                            [ span [ style [ ( "color", jsColor ) ] ] [ text "\"answer\"" ]
                            , text ": 42"
                            ]
                        , div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "}"
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            ]
                        ]
                    )
        , test "Should format Json List string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"[\\\"answer\\\", 42]\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            , text "["
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ]
                            [ span [ style [ ( "color", jsColor ) ] ] [ text "\"answer\"" ]
                            , text ","
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ]
                            [ text " 42"
                            ]
                        , div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "]"
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            ]
                        ]
                    )
        , test "Should format Json string with escaped char" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"{\\\"with\\\": \\\"new \\\\n line and a BS \\\\ yeah\\\"}\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            , text "{"
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ]
                            [ span [ style [ ( "color", jsColor ) ] ] [ text "\"with\"" ]
                            , text ": "
                            , span [ style [ ( "color", jsColor ) ] ] [ text "\"new \\n line and a BS \\ yeah\"" ]
                            ]
                        , div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "}"
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            ]
                        ]
                    )
        , test "Should format Json inside string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"some content {\\\"answer\\\": 42}\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"some content \"" ]
                            , text "{"
                            ]
                        , div [ style [ ( "padding-left", "1rem" ) ] ]
                            [ span [ style [ ( "color", jsColor ) ] ] [ text "\"answer\"" ]
                            , text ": 42"
                            ]
                        , div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "}"
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"" ]
                            ]
                        ]
                    )
        , test "Should format URL escaped char inside string" <|
            \_ ->
                Expect.equal
                    (Error.formatErrString "A = \"http://orus.io?q=%22query%22\"")
                    (div []
                        [ div [ style [ ( "padding-left", "0rem" ) ] ]
                            [ text "A = "
                            , span [ style [ ( "color", elmColor ) ] ] [ text "\"http://orus.io?q=\"query\"\"" ]
                            ]
                        ]
                    )
        ]
