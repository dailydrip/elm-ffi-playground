module App exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import FFI
import Html.Events exposing (onClick)
import Json.Decode as Decode


getHtml : String -> String
getHtml nodeId =
    FFI.sync "return window.getHtml(_0);" [ FFI.asIs nodeId ]
        |> Decode.decodeValue Decode.string
        |> Result.withDefault ""


type alias Model =
    { message : String
    , logo : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Your Elm App is working!", logo = path }, Cmd.none )


type Msg
    = Log


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Log ->
            ( { model | message = getHtml "root" }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ img
            [ src model.logo
            , onClick Log
            ]
            []
        , div [] [ text model.message ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
