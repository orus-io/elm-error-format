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
            -- "A { b = B { c = 42 } }"
            -- "BadStatus \"foo [0]._( bar ) {bar}\" { status = { code = 404, message = \"Not Found\" }, headers = Dict.fromList [(\"content-length\",\"14\"),(\"content-type\",\"text/plain; charset=utf-8\"),(\"date\",\"Wed, 14 Nov 2018 20:49:52 GMT\"),(\"server\",\"Guillotina/2.5.13\")], url = \"http://localhost:8080/db/acme/training-catalog/cd1a5dcbeb3a4e8eaa2a580348eb85bf\", body = \"404: Not Found\"}"
            "BadPayload \"Expecting a String at _.member[0].xref but instead got: null\" { status = { code = 200, message = \"OK\" }, headers = Dict.fromList [ (\"access-control-allow-credentials\",\"True\"), (\"access-control-expose-headers\",\"*\"), (\"content-length\",\"3114\"), (\"content-type\",\"application/json\"), (\"date\",\"Wed, 14 Nov 2018 18:25:34 GMT\"), (\"server\",\"Guillotina/2.5.13\") ], url = \"http://localhost:8080/db/acme/client/client1/requests/@searchcontent?q=%7B%22query%22%3A%7B%22bool%22%3A%7B%22filter%22%3A%7B%22bool%22%3A%7B%22must%22%3A%7B%22type%22%3A%7B%22value%22%3A%22TrainingRequest%22%7D%7D%7D%7D%7D%7D%2C%22sort%22%3A%5B%7B%22creation_date%22%3A%22desc%22%7D%5D%7D\", body = \"{ \\\"items_count\\\": 2, \\\"member\\\": [ { \\\"type_name\\\": \\\"TrainingRequest\\\", \\\"uuid\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"title\\\": null, \\\"modification_date\\\": \\\"2018-11-14T18:20:57.338511+00:00\\\", \\\"creation_date\\\": \\\"2018-11-14T18:20:57.338511+00:00\\\", \\\"access_roles\\\": [ \\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_acme.ClientManager\\\", \\\"guillotina_acme.ClientProfile\\\", \\\"guillotina_acme.UserSelf\\\" ], \\\"id\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"access_users\\\": [ \\\"root\\\", \\\"all-client-profiles\\\", \\\"client-manager-of-client1\\\", \\\"e6213064de68424d8dd0e25e035d3aba\\\" ], \\\"path\\\": \\\"/client/client1/requests/48f27377481541b6a92ae13273f051db\\\", \\\"depth\\\": 5, \\\"parent_uuid\\\": \\\"385800a6b8864a0abc0260760bca5207\\\", \\\"type_\\\": \\\"quotation_with_reg\\\", \\\"trainee_count\\\": 1, \\\"client_entity_ref\\\": null, \\\"product\\\": \\\"http://localhost:8080/db/acme/training-catalog/acme_product_1_merch_product_ref\\\", \\\"session\\\": \\\"http://localhost:8080/db/acme/training-sessions/97028735036e45eb97a4f52e496298e3\\\", \\\"code\\\": null, \\\"code__keyword\\\": null, \\\"type___keyword\\\": \\\"quotation_with_reg\\\", \\\"product_name\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"creators\\\": [\\\"e6213064de68424d8dd0e25e035d3aba\\\"], \\\"tags\\\": null, \\\"contributors\\\": [\\\"e6213064de68424d8dd0e25e035d3aba\\\"], \\\"xref\\\": null, \\\"@absolute_url\\\": \\\"http://localhost:8080/db/acme/client/client1/requests/48f27377481541b6a92ae13273f051db\\\", \\\"@type\\\": \\\"TrainingRequest\\\", \\\"@uid\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"@name\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"sort\\\": [1542219657338]}, {\\\"type_name\\\": \\\"TrainingRequest\\\", \\\"uuid\\\": \\\"b71ed7a4faff4ab49807cda034a64d99\\\", \\\"title\\\": null, \\\"modification_date\\\": \\\"2018-11-13T18:46:33.139805+00:00\\\", \\\"creation_date\\\": \\\"2018-11-13T18:46:33.139805+00:00\\\", \\\"access_roles\\\": [ \\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_acme.ClientManager\\\", \\\"guillotina_acme.ClientProfile\\\", \\\"guillotina_acme.UserSelf\\\" ], \\\"id\\\": \\\"REQ00000002\\\", \\\"access_users\\\": [ \\\"root\\\", \\\"all-client-profiles\\\", \\\"client-manager-of-client1\\\" ], \\\"path\\\": \\\"/client/client1/requests/REQ00000002\\\", \\\"depth\\\": 5, \\\"parent_uuid\\\": \\\"385800a6b8864a0abc0260760bca5207\\\", \\\"type_\\\": \\\"quotation_with_reg\\\", \\\"trainee_count\\\": 1, \\\"client_entity_ref\\\": \\\"client1\\\", \\\"product\\\": \\\"http://localhost:8080/db/acme/training-catalog/acme_product_1_merch_product_ref\\\", \\\"session\\\": null, \\\"code\\\": \\\"REQ00000002\\\", \\\"code__keyword\\\": \\\"REQ00000002\\\", \\\"type___keyword\\\": \\\"quotation_with_reg\\\", \\\"product_name\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"creators\\\": [ ], \\\"tags\\\": null, \\\"contributors\\\": [ ], \\\"xref\\\": \\\"REQ00000002\\\", \\\"@absolute_url\\\": \\\"http://localhost:8080/db/acme/client/client1/requests/REQ00000002\\\", \\\"@type\\\": \\\"TrainingRequest\\\", \\\"@uid\\\": \\\"b71ed7a4faff4ab49807cda034a64d99\\\", \\\"@name\\\": \\\"REQ00000002\\\", \\\"sort\\\": [ 1542134793139 ] } ] }\" }"
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
    div [] [ formatErrString model ]


formatErrString : String -> Html msg
formatErrString error =
    String.foldl parseChar (newFormater formaterDefaultOptions) error
        |> parseEOF
        |> .writer
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


type alias Formater msg =
    { options : FormaterOptions
    , contextStack : List ComplexType
    , stringState : StringState
    , escapeNext : Bool
    , writer : Writer msg
    }


newFormater : FormaterOptions -> Formater msg
newFormater options =
    { options = options
    , contextStack = []
    , stringState = NoString
    , escapeNext = False
    , writer = newWriter
    }


pushContext : ComplexType -> Formater msg -> Formater msg
pushContext t f =
    { f
        | contextStack = t :: f.contextStack
    }


popContext : Formater msg -> Formater msg
popContext f =
    { f | contextStack = List.drop 1 f.contextStack }


currentContext : Formater msg -> Maybe ComplexType
currentContext f =
    List.head f.contextStack


formaterWrite : (Writer msg -> Writer msg) -> Formater msg -> Formater msg
formaterWrite write f =
    { f
        | writer = write f.writer
    }



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



-- Parser


openContext : ComplexType -> Char -> Formater msg -> Formater msg
openContext t c f =
    f
        |> pushContext t
        |> formaterWrite
            (flushBufferAsText
                >> flushCurrentLine
                >> indent
                >> appendToBuffer c
                >> appendSingleSpace
            )


closeContext : ComplexType -> Char -> Formater msg -> Formater msg
closeContext t c f =
    f
        |> popContext
        |> formaterWrite
            (flushBufferAsText
                >> flushCurrentLine
                >> writeText (String.fromChar c)
                >> flushCurrentLine
                >> unindent
            )


parseChar : Char -> Formater msg -> Formater msg
parseChar c f =
    case ( f.stringState, c ) of
        ( _, '\\' ) ->
            { f
                | escapeNext = not f.escapeNext
            }
                |> formaterWrite
                    (appendToBuffer '\\')

        ( NoString, '{' ) ->
            f |> openContext Record '{'

        ( NoString, '}' ) ->
            f |> closeContext Record '}'

        ( NoString, '[' ) ->
            f |> openContext List '['

        ( NoString, ']' ) ->
            f |> closeContext List ']'

        ( NoString, '(' ) ->
            f
                |> pushContext Tuple
                |> formaterWrite
                    (appendToBuffer '('
                        >> appendSingleSpace
                    )

        ( NoString, ')' ) ->
            f
                |> popContext
                |> formaterWrite
                    (appendSingleSpace
                        >> appendToBuffer ')'
                    )

        ( NoString, ',' ) ->
            case currentContext f of
                Just Tuple ->
                    f
                        |> formaterWrite
                            (appendToBuffer ','
                                >> appendSingleSpace
                            )

                _ ->
                    f
                        |> formaterWrite
                            (flushBufferAsText
                                >> flushCurrentLine
                                >> appendToBuffer ','
                                >> appendSingleSpace
                            )

        ( NoString, '"' ) ->
            { f | stringState = FirstChar }
                |> formaterWrite
                    flushBufferAsText

        ( FirstChar, '"' ) ->
            (if f.escapeNext then
                { f | escapeNext = False }
                    |> formaterWrite
                        (appendToBuffer '"')
             else
                { f | stringState = NoString }
                    |> formaterWrite
                        (appendToBuffer '"'
                            >> appendToBuffer '"'
                            >> flushBufferAsColoredText f.options.stringColor
                        )
            )

        ( FirstChar, c ) ->
            { f
                | stringState = InString
                , escapeNext = False
            }
                |> formaterWrite
                    (appendToBuffer '"'
                        >> appendToBuffer c
                    )

        ( InString, '"' ) ->
            if f.escapeNext then
                { f | escapeNext = False }
                    |> formaterWrite
                        (appendToBuffer '"')
            else
                { f | stringState = NoString }
                    |> formaterWrite
                        (appendToBuffer '"'
                            >> flushBufferAsColoredText f.options.stringColor
                        )

        ( _, c ) ->
            { f | escapeNext = False }
                |> formaterWrite
                    (appendToBuffer c)


parseEOF : Formater msg -> Formater msg
parseEOF f =
    f
        |> formaterWrite
            (flushBufferAsText
                >> flushCurrentLine
            )
