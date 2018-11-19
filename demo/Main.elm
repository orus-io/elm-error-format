module Main exposing (..)

import Html exposing (Html, div, textarea)
import Html.Attributes exposing (class)
import Html.Events exposing (onInput)
import Error


-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


test : String
test =
    --       ""
    --    "A { B = { C = 1, D = 2 } }"
    --    "A = \"Elm Rox!\""
    --    "A = \"{\\\"answer\\\": 42}\""
    --    "A = \"some content {\\\"answer\\\": 42}\""
    --    "A = \"{\\\"answer\\\": \\\"42 \\n core\\\"}\""
    --    "A { B = { C = ( 1, 2 ), D = [ 1, 2 ] } }"
    --    "A = \"\\n two \\n newline\""
    --    "A = \"[\\\"answer\\\", 42]\""
    --    "\"{\\\"foo\\\": \\\"bar\\\", \\\"escaped\\\": \\\"\\n\\r\\\", \\\"empty\\\": \\\"\\\", \\\"list\\\": [1,2,3], \\\"baz\\\": 42}\""
    --    "A { b = B { c = 42 } }"
    --    "A { b = \"{\\\"foo\\n\\\": 42}\" }"
    "BadStatus { status = { code = 404, message = \"Not Found\" }, headers = Dict.fromList [(\"content-length\",\"14\"),(\"content-type\",\"text/plain; charset=utf-8\"),(\"date\",\"Wed, 14 Nov 2018 20:49:52 GMT\"),(\"server\",\"Guillotina/2.5.13\")], url = \"http://localhost:8080/db/acme/training-catalog/cd1a5dcbeb3a4e8eaa2a580348eb85bf\", body = \"404: Not Found\"}"



--    "BadPayload \"Expecting \\n a String at _.member[0].product_ref but instead got: null\" { status = { code = 200, message = \"OK\" }, headers = Dict.fromList [(\"X-Firefox-Spdy\",\"h2\"),(\"access-control-allow-credentials\",\"True\"),(\"access-control-expose-headers\",\"*\"),(\"content-encoding\",\"gzip\"),(\"content-length\",\"672\"),(\"content-type\",\"application/json\"),(\"date\",\"Thu, 15 Nov 2018 13:14:29 GMT\"),(\"server\",\"Caddy, Guillotina/2.5.13\"),(\"strict-transport-security\",\"max-age=31536000;\"),(\"vary\",\"Accept-Encoding\"),(\"x-content-type-options\",\"nosniff\"),(\"x-frame-options\",\"DENY\"),(\"x-xss-protection\",\"1; mode=block\")], url = \"https://dev-ooo.orus.io/db/ooo/diplomas/@searchcontent?q=%7B%22query%22%3A%7B%22bool%22%3A%7B%22filter%22%3A%7B%22bool%22%3A%7B%22must%22%3A%5B%7B%22type%22%3A%7B%22value%22%3A%22Diploma%22%7D%7D%2C%7B%22term%22%3A%7B%22client_entity_refs%22%3A%2255cd64c75c3f4baaa012763f693718b9%22%7D%7D%2C%7B%22term%22%3A%7B%22registration_entity_refs%22%3A%2255cd64c75c3f4baaa012763f693718b9%22%7D%7D%5D%7D%7D%7D%7D%7D\", body = \"{\\\"items_count\\\": 1, \\\"member\\\": [{\\\"type_name\\\": \\\"Diploma\\\", \\\"uuid\\\": \\\"e63a5c99a0174026a40f606789a00c4e\\\", \\\"title\\\": \\\"7d7c5cf852ed4d6eaf605d00e64106d7 \\\", \\\"modification_date\\\": \\\"2018-11-15T13:01:45.622707+00:00\\\", \\\"creation_date\\\": \\\"2018-11-15T13:01:45.622707+00:00\\\", \\\"access_roles\\\": [\\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_ooo.ClientManager\\\", \\\"guillotina_ooo.UserSelf\\\"], \\\"id\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\", \\\"access_users\\\": [\\\"root\\\", \\\"is-user\\\", \\\"user-68ad2f3c779e423196d2103694abab7c\\\", \\\"client-manager-of-55cd64c75c3f4baaa012763f693718b9\\\"], \\\"path\\\": \\\"/diplomas/68ad2f3c779e423196d2103694abab7c\\\", \\\"depth\\\": 3, \\\"parent_uuid\\\": \\\"f8d4520ebd344dd287d2a5f351d670ce\\\", \\\"cert_ref\\\": \\\"7d7c5cf852ed4d6eaf605d00e64106d7\\\", \\\"product_ref\\\": null, \\\"user_ref\\\": \\\"558df65992174729b9cb1fd83e5512ca\\\", \\\"expiration_date\\\": \\\"2020-11-15\\\", \\\"obtained_date\\\": \\\"2018-11-15\\\", \\\"to_publish\\\": true, \\\"client_entity_refs\\\": [\\\"55cd64c75c3f4baaa012763f693718b9\\\"], \\\"registration_entity_refs\\\": [\\\"55cd64c75c3f4baaa012763f693718b9\\\"], \\\"firstname\\\": \\\"Pr\\\\u00e9nom StagV3\\\", \\\"lastname\\\": \\\"Nom stagV3\\\", \\\"cert_name\\\": \\\"DIPLOME TPO\\\", \\\"cert_name__keyword\\\": \\\"DIPLOME TPO\\\", \\\"product_name\\\": \\\"\\\", \\\"product_name__keyword\\\": \\\"\\\", \\\"firstname__keyword\\\": \\\"Pr\\\\u00e9nom StagV3\\\", \\\"lastname__keyword\\\": \\\"Nom stagV3\\\", \\\"creators\\\": [], \\\"tags\\\": null, \\\"contributors\\\": [], \\\"xref\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\", \\\"@absolute_url\\\": \\\"https://dev-ooo.orus.io/db/ooo/diplomas/68ad2f3c779e423196d2103694abab7c\\\", \\\"@type\\\": \\\"Diploma\\\", \\\"@uid\\\": \\\"e63a5c99a0174026a40f606789a00c4e\\\", \\\"@name\\\": \\\"68ad2f3c779e423196d2103694abab7c\\\"}]} Yo buddy\" }"
--    "BadPayload \"Expecting an object with a field named `foo` at _.member[1] but instead got: {\\\"type_name\\\":\\\"Diploma\\\",\\\"uuid\\\":\\\"a4d796aa0939497881df10265d9202ee\\\",\\\"title\\\":\\\"771a36223fbe443b85573190c371c95d ooo_product_1_merch_product_ref\\\",\\\"modification_date\\\":\\\"2018-11-13T18:46:32.838610+00:00\\\",\\\"creation_date\\\":\\\"2018-11-13T18:46:32.838610+00:00\\\",\\\"access_roles\\\":[\\\"guillotina.Reader\\\",\\\"guillotina.Reviewer\\\",\\\"guillotina.Owner\\\",\\\"guillotina.Editor\\\",\\\"guillotina.ContainerAdmin\\\",\\\"guillotina_ooo.ClientManager\\\",\\\"guillotina_ooo.ClientProfile\\\",\\\"guillotina_ooo.UserSelf\\\"],\\\"id\\\":\\\"xref-obt-cert\\\",\\\"access_users\\\":[\\\"root\\\",\\\"all-client-profiles\\\",\\\"is-user\\\",\\\"user-xref-obt-cert\\\",\\\"client-manager-of-client1\\\"],\\\"path\\\":\\\"/diplomas/xref-obt-cert\\\",\\\"depth\\\":3,\\\"parent_uuid\\\":\\\"8c24d859bcaa4f5caa621cbf68dc13d7\\\",\\\"cert_ref\\\":\\\"771a36223fbe443b85573190c371c95d\\\",\\\"product_ref\\\":\\\"ooo_product_1_merch_product_ref\\\",\\\"user_ref\\\":\\\"3007798a1ab5486d8045be4282fa9aa9\\\",\\\"expiration_date\\\":\\\"2028-11-09\\\",\\\"obtained_date\\\":\\\"2018-11-09\\\",\\\"to_publish\\\":true,\\\"client_entity_refs\\\":[\\\"client1\\\"],\\\"registration_entity_refs\\\":[\\\"client1\\\"],\\\"firstname\\\":\\\"bb\\\",\\\"lastname\\\":\\\"aa\\\",\\\"cert_name\\\":\\\"dipl ext\\\",\\\"cert_name__keyword\\\":\\\"dipl ext\\\",\\\"product_name\\\":\\\"Maîtriser le rôle des intervenants dans une opération de construction\\\",\\\"product_name__keyword\\\":\\\"Maîtriser le rôle des intervenants dans une opération de construction\\\",\\\"firstname__keyword\\\":\\\"bb\\\",\\\"lastname__keyword\\\":\\\"aa\\\",\\\"creators\\\":[],\\\"tags\\\":null,\\\"contributors\\\":[],\\\"xref\\\":\\\"xref-obt-cert\\\",\\\"@absolute_url\\\":\\\"http://localhost:8080/db/ooo/diplomas/xref-obt-cert\\\",\\\"@type\\\":\\\"Diploma\\\",\\\"@uid\\\":\\\"a4d796aa0939497881df10265d9202ee\\\",\\\"@name\\\":\\\"xref-obt-cert\\\"}\" { status = { code = 200, message = \"OK\" }, headers = Dict.fromList [(\"access-control-allow-credentials\",\"True\"),(\"access-control-expose-headers\",\"*\"),(\"content-length\",\"3326\"),(\"content-type\",\"application/json\"),(\"date\",\"Sun, 18 Nov 2018 14:18:12 GMT\"),(\"server\",\"Guillotina/2.5.13\")], url = \"http://localhost:8080/db/ooo/diplomas/@searchcontent?q=%7B%22query%22%3A%7B%22bool%22%3A%7B%22filter%22%3A%7B%22bool%22%3A%7B%22must%22%3A%5B%7B%22type%22%3A%7B%22value%22%3A%22Diploma%22%7D%7D%2C%7B%22term%22%3A%7B%22client_entity_refs%22%3A%22client1%22%7D%7D%2C%7B%22term%22%3A%7B%22registration_entity_refs%22%3A%22client1%22%7D%7D%5D%7D%7D%7D%7D%7D\", body = \"{\\\"items_count\\\": 2, \\\"member\\\": [{\\\"type_name\\\": \\\"Diploma\\\", \\\"uuid\\\": \\\"0c9ec460b63c4926aa4561d83f3ac832\\\", \\\"title\\\": \\\"DIP_ACTCONSTR_MASSCARD ooo_product_1_merch_product_ref\\\", \\\"modification_date\\\": \\\"2018-11-13T18:46:32.851562+00:00\\\", \\\"creation_date\\\": \\\"2018-11-13T18:46:32.851562+00:00\\\", \\\"access_roles\\\": [\\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_ooo.ClientManager\\\", \\\"guillotina_ooo.ClientProfile\\\", \\\"guillotina_ooo.UserSelf\\\"], \\\"id\\\": \\\"xref-obt-cert2\\\", \\\"access_users\\\": [\\\"root\\\", \\\"all-client-profiles\\\", \\\"is-user\\\", \\\"user-xref-obt-cert2\\\", \\\"client-manager-of-client1\\\"], \\\"path\\\": \\\"/diplomas/xref-obt-cert2\\\", \\\"depth\\\": 3, \\\"parent_uuid\\\": \\\"8c24d859bcaa4f5caa621cbf68dc13d7\\\", \\\"cert_ref\\\": \\\"DIP_ACTCONSTR_MASSCARD\\\", \\\"product_ref\\\": \\\"ooo_product_1_merch_product_ref\\\", \\\"user_ref\\\": \\\"9007798a1ab5486d8045b24282fa9aa9\\\", \\\"expiration_date\\\": \\\"2028-11-09\\\", \\\"obtained_date\\\": \\\"2018-11-09\\\", \\\"to_publish\\\": true, \\\"client_entity_refs\\\": [\\\"client1\\\"], \\\"registration_entity_refs\\\": [\\\"client1\\\"], \\\"firstname\\\": \\\"John\\\", \\\"lastname\\\": \\\"Doe\\\", \\\"cert_name\\\": \\\"DIP_ACTCONSTR_MASSCARD\\\", \\\"cert_name__keyword\\\": \\\"DIP_ACTCONSTR_MASSCARD\\\", \\\"product_name\\\": \\\"Ma\\\\u00eetriser le r\\\\u00f4le des intervenants dans une op\\\\u00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Ma\\\\u00eetriser le r\\\\u00f4le des intervenants dans une op\\\\u00e9ration de construction\\\", \\\"firstname__keyword\\\": \\\"John\\\", \\\"lastname__keyword\\\": \\\"Doe\\\", \\\"creators\\\": [], \\\"tags\\\": null, \\\"contributors\\\": [], \\\"xref\\\": \\\"xref-obt-cert2\\\", \\\"@absolute_url\\\": \\\"http://localhost:8080/db/ooo/diplomas/xref-obt-cert2\\\", \\\"@type\\\": \\\"Diploma\\\", \\\"@uid\\\": \\\"0c9ec460b63c4926aa4561d83f3ac832\\\", \\\"@name\\\": \\\"xref-obt-cert2\\\"}, {\\\"type_name\\\": \\\"Diploma\\\", \\\"uuid\\\": \\\"a4d796aa0939497881df10265d9202ee\\\", \\\"title\\\": \\\"771a36223fbe443b85573190c371c95d ooo_product_1_merch_product_ref\\\", \\\"modification_date\\\": \\\"2018-11-13T18:46:32.838610+00:00\\\", \\\"creation_date\\\": \\\"2018-11-13T18:46:32.838610+00:00\\\", \\\"access_roles\\\": [\\\"guillotina.Reader\\\", \\\"guillotina.Reviewer\\\", \\\"guillotina.Owner\\\", \\\"guillotina.Editor\\\", \\\"guillotina.ContainerAdmin\\\", \\\"guillotina_ooo.ClientManager\\\", \\\"guillotina_ooo.ClientProfile\\\", \\\"guillotina_ooo.UserSelf\\\"], \\\"id\\\": \\\"xref-obt-cert\\\", \\\"access_users\\\": [\\\"root\\\", \\\"all-client-profiles\\\", \\\"is-user\\\", \\\"user-xref-obt-cert\\\", \\\"client-manager-of-client1\\\"], \\\"path\\\": \\\"/diplomas/xref-obt-cert\\\", \\\"depth\\\": 3, \\\"parent_uuid\\\": \\\"8c24d859bcaa4f5caa621cbf68dc13d7\\\", \\\"cert_ref\\\": \\\"771a36223fbe443b85573190c371c95d\\\", \\\"product_ref\\\": \\\"ooo_product_1_merch_product_ref\\\", \\\"user_ref\\\": \\\"3007798a1ab5486d8045be4282fa9aa9\\\", \\\"expiration_date\\\": \\\"2028-11-09\\\", \\\"obtained_date\\\": \\\"2018-11-09\\\", \\\"to_publish\\\": true, \\\"client_entity_refs\\\": [\\\"client1\\\"], \\\"registration_entity_refs\\\": [\\\"client1\\\"], \\\"firstname\\\": \\\"bb\\\", \\\"lastname\\\": \\\"aa\\\", \\\"cert_name\\\": \\\"dipl ext\\\", \\\"cert_name__keyword\\\": \\\"dipl ext\\\", \\\"product_name\\\": \\\"Ma\\\\u00eetriser le r\\\\u00f4le des intervenants dans une op\\\\u00e9ration de construction\\\", \\\"product_name__keyword\\\": \\\"Ma\\\\u00eetriser le r\\\\u00f4le des intervenants dans une op\\\\u00e9ration de construction\\\", \\\"firstname__keyword\\\": \\\"bb\\\", \\\"lastname__keyword\\\": \\\"aa\\\", \\\"creators\\\": [], \\\"tags\\\": null, \\\"contributors\\\": [], \\\"xref\\\": \\\"xref-obt-cert\\\", \\\"@absolute_url\\\": \\\"http://localhost:8080/db/ooo/diplomas/xref-obt-cert\\\", \\\"@type\\\": \\\"Diploma\\\", \\\"@uid\\\": \\\"a4d796aa0939497881df10265d9202ee\\\", \\\"@name\\\": \\\"xref-obt-cert\\\"}]}\" }"
-- MODEL


type alias Model =
    { left : Error.Model
    , right : Error.Model
    , test : Error.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { left = "", right = "", test = test }, Cmd.none )



-- UPDATE


type Msg
    = ChangeLeft String
    | ChangeRight String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLeft str ->
            { model | left = str } ! []

        ChangeRight str ->
            { model | right = str } ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ div [ class "flex-grid" ]
            [ div [ class "col" ]
                [ div [] [ textarea [ onInput ChangeLeft ] [] ]
                , div [] [ Error.view model.left ]
                ]
            , div [ class "col" ]
                [ div [] [ textarea [ onInput ChangeRight ] [] ]
                , div [] [ Error.view model.right ]
                ]
            ]
        , div [ class "flex-grid" ] [ div [ class "col" ] [ Error.view model.test ] ]
        ]
