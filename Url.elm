module Url exposing (..)

import Dict exposing (Dict)
import Buffer
import Writer exposing (Writer)
import Reader
    exposing
        ( Reader
        , InputChar
        , toChar
        )


type alias Formater =
    { inQueryString : Bool
    , moduloSeen : Bool
    }


init : Formater
init =
    { inQueryString = False
    , moduloSeen = False
    }


checkConvert : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
checkConvert c ( formater, writer ) =
    getChar
        (Buffer.take 2 writer.buffer
            |> String.fromList
        )
        |> Maybe.map
            (\c ->
                ( { formater | moduloSeen = False }
                , writer
                    |> Writer.dropBuffer 3
                    |> Writer.appendToBuffer c
                )
            )
        |> Maybe.withDefault ( formater, writer )


parseChar : InputChar -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.inQueryString, formater.moduloSeen, c ) of
        ( False, _, Reader.QuestionMark ) ->
            ( { formater | inQueryString = True }
            , writer
                |> Writer.appendToBuffer '?'
            )

        ( _, False, Reader.Modulo ) ->
            ( { formater | moduloSeen = True }
            , writer
                |> Writer.appendToBuffer '%'
            )

        ( True, True, c ) ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar c)
            )
                |> checkConvert c

        ( _, _, c ) ->
            ( formater
            , writer |> Writer.appendToBuffer (toChar c)
            )


getChar : String -> Maybe Char
getChar s =
    Dict.get s map


map : Dict String Char
map =
    Dict.fromList
        [ ( "20", ' ' )
        , ( "21", '!' )
        , ( "22", '"' )
        , ( "23", '#' )
        , ( "24", '$' )
        , ( "25", '%' )
        , ( "26", '&' )
        , ( "27", '\'' )
        , ( "28", '(' )
        , ( "29", ')' )
        , ( "2A", '*' )
        , ( "2B", '+' )
        , ( "2C", ',' )
        , ( "2D", '-' )
        , ( "2E", '.' )
        , ( "2F", '/' )
        , ( "3A", ':' )
        , ( "3B", ';' )
        , ( "3C", '<' )
        , ( "3D", '=' )
        , ( "3E", '>' )
        , ( "3F", '?' )
        , ( "40", '@' )
        , ( "5B", '[' )
        , ( "5C", '\\' )
        , ( "5D", ']' )
        , ( "5E", '^' )
        , ( "5F", '_' )
        , ( "60", '`' )
        , ( "7B", '{' )
        , ( "7C", '|' )
        , ( "7D", '}' )
        , ( "7E", '~' )
        ]
