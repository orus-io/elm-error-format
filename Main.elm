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
            "BadStatus { status = { code = 404, message = \"Not Found\" }, headers = Dict.fromList [(\"content-length\",\"14\"),(\"content-type\",\"text/plain; charset=utf-8\"),(\"date\",\"Wed, 14 Nov 2018 20:49:52 GMT\"),(\"server\",\"Guillotina/2.5.13\")], url = \"http://localhost:8080/db/acme/training-catalog/cd1a5dcbeb3a4e8eaa2a580348eb85bf\", body = \"404: Not Found\"}"

        -- "BadPayload \"Expecting a String at _.member[0].xref but instead got: null\" { status = { code = 200, message = \"OK\" }, headers = Dict.fromList [ (\"access-control-allow-credentials\",\"True\"), (\"access-control-expose-headers\",\"*\"), (\"content-length\",\"3114\"), (\"content-type\",\"application/json\"), (\"date\",\"Wed, 14 Nov 2018 18:25:34 GMT\"), (\"server\",\"Guillotina/2.5.13\") ], url = \"http://localhost:8080/db/acme/client/client1/requests/@searchcontent?q=%7B%22query%22%3A%7B%22bool%22%3A%7B%22filter%22%3A%7B%22bool%22%3A%7B%22must%22%3A%7B%22type%22%3A%7B%22value%22%3A%22TrainingRequest%22%7D%7D%7D%7D%7D%7D%2C%22sort%22%3A%5B%7B%22creation_date%22%3A%22desc%22%7D%5D%7D\", body = \"{ \\\"items_count\\\": 2, \\\"member\\\": [ { \\\"type_name\\\": \\\"TrainingRequest\\\", \\\"uuid\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"title\\\": null, \\\"modification_date\\\": \\\"2018-11-14T18:20:57.338511+00:00\\\", \\\"creation_date\\\": \\\"2018-11-14T18:20:57.338511+00:00\\\", \\\"access_roles\\\": [ \\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_acme.ClientManager\\\", \\\"guillotina_acme.ClientProfile\\\", \\\"guillotina_acme.UserSelf\\\" ], \\\"id\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"access_users\\\": [ \\\"root\\\", \\\"all-client-profiles\\\", \\\"client-manager-of-client1\\\", \\\"e6213064de68424d8dd0e25e035d3aba\\\" ], \\\"path\\\": \\\"/client/client1/requests/48f27377481541b6a92ae13273f051db\\\", \\\"depth\\\": 5, \\\"parent_uuid\\\": \\\"385800a6b8864a0abc0260760bca5207\\\", \\\"type_\\\": \\\"quotation_with_reg\\\", \\\"trainee_count\\\": 1, \\\"client_entity_ref\\\": null, \\\"product\\\": \\\"http://localhost:8080/db/acme/training-catalog/acme_product_1_merch_product_ref\\\", \\\"session\\\": \\\"http://localhost:8080/db/acme/training-sessions/97028735036e45eb97a4f52e496298e3\\\", \\\"code\\\": null, \\\"code__keyword\\\": null, \\\"type___keyword\\\": \\\"quotation_with_reg\\\", \\\"product_name\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"creators\\\": [\\\"e6213064de68424d8dd0e25e035d3aba\\\"], \\\"tags\\\": null, \\\"contributors\\\": [\\\"e6213064de68424d8dd0e25e035d3aba\\\"], \\\"xref\\\": null, \\\"@absolute_url\\\": \\\"http://localhost:8080/db/acme/client/client1/requests/48f27377481541b6a92ae13273f051db\\\", \\\"@type\\\": \\\"TrainingRequest\\\", \\\"@uid\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"@name\\\": \\\"48f27377481541b6a92ae13273f051db\\\", \\\"sort\\\": [1542219657338]}, {\\\"type_name\\\": \\\"TrainingRequest\\\", \\\"uuid\\\": \\\"b71ed7a4faff4ab49807cda034a64d99\\\", \\\"title\\\": null, \\\"modification_date\\\": \\\"2018-11-13T18:46:33.139805+00:00\\\", \\\"creation_date\\\": \\\"2018-11-13T18:46:33.139805+00:00\\\", \\\"access_roles\\\": [ \\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_acme.ClientManager\\\", \\\"guillotina_acme.ClientProfile\\\", \\\"guillotina_acme.UserSelf\\\" ], \\\"id\\\": \\\"REQ00000002\\\", \\\"access_users\\\": [ \\\"root\\\", \\\"all-client-profiles\\\", \\\"client-manager-of-client1\\\" ], \\\"path\\\": \\\"/client/client1/requests/REQ00000002\\\", \\\"depth\\\": 5, \\\"parent_uuid\\\": \\\"385800a6b8864a0abc0260760bca5207\\\", \\\"type_\\\": \\\"quotation_with_reg\\\", \\\"trainee_count\\\": 1, \\\"client_entity_ref\\\": \\\"client1\\\", \\\"product\\\": \\\"http://localhost:8080/db/acme/training-catalog/acme_product_1_merch_product_ref\\\", \\\"session\\\": null, \\\"code\\\": \\\"REQ00000002\\\", \\\"code__keyword\\\": \\\"REQ00000002\\\", \\\"type___keyword\\\": \\\"quotation_with_reg\\\", \\\"product_name\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Mau00eetriser le ru00f4le des intervenants dans une opu00e9ration de construction\\\", \\\"creators\\\": [ ], \\\"tags\\\": null, \\\"contributors\\\": [ ], \\\"xref\\\": \\\"REQ00000002\\\", \\\"@absolute_url\\\": \\\"http://localhost:8080/db/acme/client/client1/requests/REQ00000002\\\", \\\"@type\\\": \\\"TrainingRequest\\\", \\\"@uid\\\": \\\"b71ed7a4faff4ab49807cda034a64d99\\\", \\\"@name\\\": \\\"REQ00000002\\\", \\\"sort\\\": [ 1542134793139 ] } ] }\" }"
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
    String.foldl parseChar newFormater error
        |> parseEOF
        |> render



-- Formater


type alias Formater msg =
    { contextStack : List ComplexType
    , buffer : Buffer
    , currentLine : List (Html msg)
    , indent : Int
    , output : List (Html msg)
    }


newFormater : Formater msg
newFormater =
    { contextStack = []
    , buffer = []
    , currentLine = []
    , indent = 0
    , output = []
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


writeText : String -> Formater msg -> Formater msg
writeText s f =
    { f
        | currentLine = List.append f.currentLine [ text s ]
    }


popBuffer : Formater msg -> ( String, Formater msg )
popBuffer f =
    ( String.fromList f.buffer
    , { f
        | buffer = []
      }
    )


flushBufferAsText : Formater msg -> Formater msg
flushBufferAsText f =
    let
        ( s, newF ) =
            popBuffer f
    in
        newF |> writeText s


appendToBuffer : Char -> Formater msg -> Formater msg
appendToBuffer c f =
    { f
        | buffer = bufferAppend c f.buffer
    }


indent : Formater msg -> Formater msg
indent f =
    { f
        | indent = f.indent + 1
    }


unindent : Formater msg -> Formater msg
unindent f =
    { f
        | indent = f.indent - 1
    }


padding : Int -> Attribute msg
padding indent =
    style [ ( "padding-left", ((toString (indent * 2)) ++ "rem") ) ]


flushCurrentLine : Formater msg -> Formater msg
flushCurrentLine f =
    { f
        | output =
            List.append f.output
                [ div [ padding f.indent ] f.currentLine ]
        , currentLine = []
    }


render : Formater msg -> Html msg
render f =
    div [] f.output



-- Buffer


type alias Buffer =
    List Char


bufferAppend : Char -> Buffer -> Buffer
bufferAppend c b =
    List.append b [ c ]



-- Context


type ComplexType
    = List
    | Record
    | Tuple



-- Parser


openContext : ComplexType -> Char -> Formater msg -> Formater msg
openContext t c f =
    f
        |> appendToBuffer c
        |> flushBufferAsText
        |> flushCurrentLine
        |> indent
        |> pushContext t


closeContext : ComplexType -> Char -> Formater msg -> Formater msg
closeContext t c f =
    f
        |> flushBufferAsText
        |> flushCurrentLine
        |> popContext
        |> unindent
        |> appendToBuffer c


parseChar : Char -> Formater msg -> Formater msg
parseChar c f =
    case c of
        '{' ->
            f |> openContext Record '{'

        '}' ->
            f |> closeContext Record '}'

        '[' ->
            f |> openContext List '['

        ']' ->
            f |> closeContext List ']'

        '(' ->
            f
                |> appendToBuffer '('
                |> pushContext Tuple

        ')' ->
            f
                |> appendToBuffer ')'
                |> popContext

        ',' ->
            case currentContext f of
                Just Tuple ->
                    f |> appendToBuffer ','

                _ ->
                    f
                        |> appendToBuffer ','
                        |> flushBufferAsText
                        |> flushCurrentLine

        c ->
            f
                |> appendToBuffer c
                |> Debug.log "Default"


parseEOF : Formater msg -> Formater msg
parseEOF f =
    f
        |> flushBufferAsText
        |> flushCurrentLine
