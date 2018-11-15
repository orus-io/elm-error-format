module Main exposing (..)

import Html exposing (Html, Attribute, div, text, span)
import Html.Attributes exposing (style)


-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    let
        errorMsg =
            ---"\"{\\\"foo\\\": \\\"bar\\\", \\\"escaped\\\": \\\"\\n\\r\\\", \\\"empty\\\": \\\"\\\", \\\"list\\\": [1,2,3], \\\"baz\\\": 42}\""
            -- "A { b = B { c = 42 } }"
            -- "BadStatus \"foo [0]._( bar ) {bar}\" { status = { code = 404, message = \"Not Found\" }, headers = Dict.fromList [(\"content-length\",\"14\"),(\"content-type\",\"text/plain; charset=utf-8\"),(\"date\",\"Wed, 14 Nov 2018 20:49:52 GMT\"),(\"server\",\"Guillotina/2.5.13\")], url = \"http://localhost:8080/db/acme/training-catalog/cd1a5dcbeb3a4e8eaa2a580348eb85bf\", body = \"404: Not Found\"}"
            "BadPayload \"Expecting a String at _.member[0].product_ref but instead got: null\" { status = { code = 200, message = \"OK\" }, headers = Dict.fromList [(\"X-Firefox-Spdy\",\"h2\"),(\"access-control-allow-credentials\",\"True\"),(\"access-control-expose-headers\",\"*\"),(\"content-encoding\",\"gzip\"),(\"content-length\",\"672\"),(\"content-type\",\"application/json\"),(\"date\",\"Thu, 15 Nov 2018 13:14:29 GMT\"),(\"server\",\"Caddy, Guillotina/2.5.13\"),(\"strict-transport-security\",\"max-age=31536000;\"),(\"vary\",\"Accept-Encoding\"),(\"x-content-type-options\",\"nosniff\"),(\"x-frame-options\",\"DENY\"),(\"x-xss-protection\",\"1; mode=block\")], url = \"https://dev-cnpp.orus.io/db/cnpp/diplomas/@searchcontent?q=%7B%22query%22%3A%7B%22bool%22%3A%7B%22filter%22%3A%7B%22bool%22%3A%7B%22must%22%3A%5B%7B%22type%22%3A%7B%22value%22%3A%22Diploma%22%7D%7D%2C%7B%22term%22%3A%7B%22client_entity_refs%22%3A%2255cd64c75c3f4baaa012763f693718b9%22%7D%7D%2C%7B%22term%22%3A%7B%22registration_entity_refs%22%3A%2255cd64c75c3f4baaa012763f693718b9%22%7D%7D%5D%7D%7D%7D%7D%7D\", body = \"{\\\"items_count\\\": 1, \\\"member\\\": [{\\\"type_name\\\": \\\"Diploma\\\", \\\"uuid\\\": \\\"e63a5c99a0174026a40f606789a00c4e\\\", \\\"title\\\": \\\"7d7c5cf852ed4d6eaf605d00e64106d7 \\\", \\\"modification_date\\\": \\\"2018-11-15T13:01:45.622707+00:00\\\", \\\"creation_date\\\": \\\"2018-11-15T13:01:45.622707+00:00\\\", \\\"access_roles\\\": [\\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_cnpp.ClientManager\\\", \\\"guillotina_cnpp.UserSelf\\\"], \\\"id\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\", \\\"access_users\\\": [\\\"root\\\", \\\"is-trainee\\\", \\\"trainee-68ad2f3c779e423196d2103694abab7c\\\", \\\"client-manager-of-55cd64c75c3f4baaa012763f693718b9\\\"], \\\"path\\\": \\\"/diplomas/68ad2f3c779e423196d2103694abab7c\\\", \\\"depth\\\": 3, \\\"parent_uuid\\\": \\\"f8d4520ebd344dd287d2a5f351d670ce\\\", \\\"cert_ref\\\": \\\"7d7c5cf852ed4d6eaf605d00e64106d7\\\", \\\"product_ref\\\": null, \\\"trainee_ref\\\": \\\"558df65992174729b9cb1fd83e5512ca\\\", \\\"expiration_date\\\": \\\"2020-11-15\\\", \\\"obtained_date\\\": \\\"2018-11-15\\\", \\\"to_publish\\\": true, \\\"client_entity_refs\\\": [\\\"55cd64c75c3f4baaa012763f693718b9\\\"], \\\"registration_entity_refs\\\": [\\\"55cd64c75c3f4baaa012763f693718b9\\\"], \\\"firstname\\\": \\\"Pr\\\\u00e9nom StagV3\\\", \\\"lastname\\\": \\\"Nom stagV3\\\", \\\"cert_name\\\": \\\"DIPLOME TPO\\\", \\\"cert_name__keyword\\\": \\\"DIPLOME TPO\\\", \\\"product_name\\\": \\\"\\\", \\\"product_name__keyword\\\": \\\"\\\", \\\"firstname__keyword\\\": \\\"Pr\\\\u00e9nom StagV3\\\", \\\"lastname__keyword\\\": \\\"Nom stagV3\\\", \\\"creators\\\": [], \\\"tags\\\": null, \\\"contributors\\\": [], \\\"xref\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\", \\\"@absolute_url\\\": \\\"https://dev-cnpp.orus.io/db/cnpp/diplomas/68ad2f3c779e423196d2103694abab7c\\\", \\\"@type\\\": \\\"Diploma\\\", \\\"@uid\\\": \\\"e63a5c99a0174026a40f606789a00c4e\\\", \\\"@name\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\"}]}\" }"
    in
        ( errorMsg, Cmd.none )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div [ style [ ( "font-family", "monospace" ) ] ] [ formatErrString model ]


formatErrString : String -> Html msg
formatErrString error =
    String.foldl parseChar ( newFormater formaterDefaultOptions, newWriter ) error
        |> parseEOF
        |> Tuple.second
        |> render



-- Writer


type alias Writer msg =
    { buffer : Buffer
    , ignoreNextSpace : Bool
    , currentLine : List (Html msg)
    , indent : Int
    , output : List (Html msg)
    }


newWriter : Writer msg
newWriter =
    { buffer = emptyBuffer
    , ignoreNextSpace = False
    , currentLine = []
    , indent = 0
    , output = []
    }


popBuffer : Writer msg -> ( String, Writer msg )
popBuffer w =
    ( w.buffer |> bufferAsString
    , { w | buffer = emptyBuffer }
    )


appendToBuffer : Char -> Writer msg -> Writer msg
appendToBuffer c w =
    case ( w.ignoreNextSpace, c ) of
        ( True, ' ' ) ->
            w

        ( _, _ ) ->
            { w
                | buffer = bufferAppend c w.buffer
                , ignoreNextSpace = False
            }


appendSingleSpace : Writer msg -> Writer msg
appendSingleSpace w =
    { w
        | ignoreNextSpace = True
        , buffer =
            w.buffer
                |> bufferRStrip ' '
                |> bufferAppend ' '
    }


writeText : String -> Writer msg -> Writer msg
writeText s w =
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
    style [ ( "padding-left", ((toString (indent * 2)) ++ "rem") ) ]


flushCurrentLine : Writer msg -> Writer msg
flushCurrentLine w =
    { w
        | output =
            List.append w.output
                [ div [ padding w.indent ] w.currentLine ]
        , currentLine = []
    }


render : Writer msg -> Html msg
render w =
    div [] w.output



-- Formater


type alias FormaterOptions =
    { stringColor : String }


formaterDefaultOptions : FormaterOptions
formaterDefaultOptions =
    { stringColor = "teal" }


type alias Formater =
    { options : FormaterOptions
    , contextStack : List ComplexType
    , stringState : StringState
    , escapeNext : Bool
    , jsonFormater : JsonFormater
    }


newFormater : FormaterOptions -> Formater
newFormater options =
    { options = options
    , contextStack = []
    , stringState = NoString
    , escapeNext = False
    , jsonFormater = newJsonFormater jsonFormaterDefaultOptions
    }


pushContext : ComplexType -> Formater -> Formater
pushContext t f =
    { f
        | contextStack = t :: f.contextStack
    }


popContext : Formater -> Formater
popContext f =
    { f | contextStack = List.drop 1 f.contextStack }


currentContext : Formater -> Maybe ComplexType
currentContext f =
    List.head f.contextStack



-- Json Formater


type alias JsonFormaterOptions =
    { stringColor : String }


jsonFormaterDefaultOptions : JsonFormaterOptions
jsonFormaterDefaultOptions =
    { stringColor = "orangered" }


type alias JsonFormater =
    { options : JsonFormaterOptions
    , contextStack : List ComplexType
    , escapeNext : Bool
    }


setJFEscapeNext : Bool -> JsonFormater -> JsonFormater
setJFEscapeNext v jf =
    { jf | escapeNext = v }


newJsonFormater : JsonFormaterOptions -> JsonFormater
newJsonFormater options =
    { options = options
    , contextStack = []
    , escapeNext = False
    }


pushJsonContext : ComplexType -> JsonFormater -> JsonFormater
pushJsonContext t f =
    { f
        | contextStack = t :: f.contextStack
    }


popJsonContext : JsonFormater -> JsonFormater
popJsonContext f =
    { f | contextStack = List.drop 1 f.contextStack }


currentJsonContext : JsonFormater -> Maybe ComplexType
currentJsonContext f =
    List.head f.contextStack



-- Buffer


type alias Buffer =
    List Char


emptyBuffer : Buffer
emptyBuffer =
    []


bufferAppend : Char -> Buffer -> Buffer
bufferAppend c b =
    c :: b


bufferRStrip : Char -> Buffer -> Buffer
bufferRStrip c b =
    case b of
        h :: t ->
            if h == c then
                bufferRStrip c t
            else
                b

        b ->
            b


bufferAsString : Buffer -> String
bufferAsString =
    List.reverse >> String.fromList



-- Context


type ComplexType
    = List
    | Record
    | Tuple


type StringState
    = NoString
    | FirstChar
    | InString
    | JsonString JsonStringState


type JsonStringState
    = JSNoString
    | JSFirstChar
    | JSInString



-- Parser


openContext : ComplexType -> Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
openContext t c ( formater, writer ) =
    ( formater
        |> pushContext t
    , writer
        |> flushBufferAsText
        >> flushCurrentLine
        >> indent
        >> appendToBuffer c
        >> appendSingleSpace
    )


closeContext : ComplexType -> Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeContext t c ( formater, writer ) =
    ( formater
        |> popContext
    , writer
        |> flushBufferAsText
        >> flushCurrentLine
        >> writeText (String.fromChar c)
        >> flushCurrentLine
        >> unindent
    )


openJsonContext : ComplexType -> Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
openJsonContext t c ( formater, writer ) =
    ( { formater | jsonFormater = formater.jsonFormater |> pushJsonContext t }
    , writer
        |> appendToBuffer c
        >> flushBufferAsText
        >> flushCurrentLine
        >> indent
    )


closeJsonContext : ComplexType -> Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
closeJsonContext t c ( formater, writer ) =
    ( { formater | jsonFormater = formater.jsonFormater |> popJsonContext }
    , writer
        |> flushBufferAsText
        >> flushCurrentLine
        >> writeText (String.fromChar c)
        >> unindent
    )


parseChar : Char -> ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseChar c ( formater, writer ) =
    case ( formater.stringState, c ) of
        ( stringState, '\\' ) ->
            case stringState of
                JsonString _ ->
                    ( { formater
                        | jsonFormater =
                            formater.jsonFormater
                                |> setJFEscapeNext (not formater.escapeNext)
                      }
                    , writer
                    )

                _ ->
                    ( { formater
                        | escapeNext = not formater.escapeNext
                      }
                    , writer
                        |> appendToBuffer '\\'
                    )

        ( NoString, '{' ) ->
            ( formater, writer ) |> openContext Record '{'

        ( NoString, '}' ) ->
            ( formater, writer ) |> closeContext Record '}'

        ( NoString, '[' ) ->
            ( formater, writer ) |> openContext List '['

        ( NoString, ']' ) ->
            ( formater, writer ) |> closeContext List ']'

        ( NoString, '(' ) ->
            ( formater
                |> pushContext Tuple
            , writer
                |> appendToBuffer '('
                >> appendSingleSpace
            )

        ( NoString, ')' ) ->
            ( formater
                |> popContext
            , writer
                |> appendSingleSpace
                >> appendToBuffer ')'
            )

        ( NoString, ',' ) ->
            case currentContext formater of
                Just Tuple ->
                    ( formater
                    , writer
                        |> appendToBuffer ','
                        >> appendSingleSpace
                    )

                _ ->
                    ( formater
                    , writer
                        |> flushBufferAsText
                        >> flushCurrentLine
                        >> appendToBuffer ','
                        >> appendSingleSpace
                    )

        ( NoString, '"' ) ->
            ( { formater | stringState = FirstChar }
            , writer
                |> flushBufferAsText
            )

        ( FirstChar, '"' ) ->
            (if formater.escapeNext then
                ( { formater | escapeNext = False }
                , writer
                    |> appendToBuffer '"'
                )
             else
                ( { formater | stringState = NoString }
                , writer
                    |> appendToBuffer '"'
                    >> appendToBuffer '"'
                    >> flushBufferAsColoredText formater.options.stringColor
                )
            )

        ( FirstChar, c ) ->
            if List.member c [ '{', '[' ] then
                {- Enter JSON -}
                ( { formater
                    | stringState = JsonString JSNoString
                    , escapeNext = False
                  }
                , writer
                    |> appendToBuffer '`'
                    >> flushBufferAsText
                    >> flushCurrentLine
                    >> appendToBuffer c
                    >> flushBufferAsText
                    >> flushCurrentLine
                    >> indent
                )
            else
                ( { formater
                    | stringState = InString
                    , escapeNext = False
                  }
                , writer
                    |> appendToBuffer '"'
                    >> appendToBuffer c
                )

        ( InString, '"' ) ->
            if formater.escapeNext then
                ( { formater | escapeNext = False }
                , writer
                    |> appendToBuffer '"'
                )
            else
                ( { formater | stringState = NoString }
                , writer
                    |> appendToBuffer '"'
                    >> flushBufferAsColoredText formater.options.stringColor
                )

        ( JsonString JSNoString, '{' ) ->
            ( formater, writer ) |> openJsonContext Record '{'

        ( JsonString JSNoString, '}' ) ->
            ( formater, writer ) |> closeJsonContext Record '}'

        ( JsonString JSNoString, '[' ) ->
            ( formater, writer ) |> openJsonContext List '['

        ( JsonString JSNoString, ']' ) ->
            ( formater, writer ) |> closeJsonContext List ']'

        ( JsonString JSNoString, ',' ) ->
            ( { formater
                | jsonFormater =
                    formater.jsonFormater
                        |> setJFEscapeNext False
              }
            , writer
                |> appendToBuffer ','
                >> flushBufferAsText
                >> flushCurrentLine
                >> flushCurrentLine
            )

        ( JsonString JSNoString, '"' ) ->
            if formater.jsonFormater.escapeNext then
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                    , stringState = JsonString JSFirstChar
                  }
                , writer
                    |> flushBufferAsText
                )
            else
                {- Escape JSON -}
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                    , stringState = NoString
                  }
                , writer
                    |> appendToBuffer '`'
                    >> flushBufferAsText
                    >> flushCurrentLine
                )

        ( JsonString JSFirstChar, '"' ) ->
            ( { formater
                | jsonFormater =
                    formater.jsonFormater
                        |> setJFEscapeNext False
                , stringState = JsonString JSNoString
              }
            , writer
                |> appendToBuffer '"'
                |> appendToBuffer '"'
                |> flushBufferAsColoredText formater.jsonFormater.options.stringColor
            )

        ( JsonString JSFirstChar, c ) ->
            if formater.jsonFormater.escapeNext then
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                    , stringState = JsonString JSInString
                  }
                , writer
                    |> appendToBuffer '"'
                    |> appendToBuffer '\\'
                    |> appendToBuffer c
                )
            else
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                    , stringState = JsonString JSInString
                  }
                , writer
                    |> appendToBuffer '"'
                    |> appendToBuffer c
                )

        ( JsonString JSInString, '"' ) ->
            if formater.escapeNext then
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                  }
                , writer
                    |> appendToBuffer '\\'
                    |> appendToBuffer '"'
                )
            else
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                    , stringState = JsonString JSNoString
                  }
                , writer
                    |> appendToBuffer '"'
                    |> flushBufferAsColoredText formater.jsonFormater.options.stringColor
                )

        ( JsonString _, c ) ->
            if formater.jsonFormater.escapeNext then
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                  }
                , writer
                    |> appendToBuffer '\\'
                    |> appendToBuffer c
                )
            else
                ( { formater
                    | jsonFormater =
                        formater.jsonFormater
                            |> setJFEscapeNext False
                  }
                , writer
                    |> appendToBuffer c
                )

        ( _, c ) ->
            ( { formater | escapeNext = False }
            , writer
                |> appendToBuffer c
            )


parseEOF : ( Formater, Writer msg ) -> ( Formater, Writer msg )
parseEOF ( formater, writer ) =
    ( formater
    , writer
        |> flushBufferAsText
        >> flushCurrentLine
    )
