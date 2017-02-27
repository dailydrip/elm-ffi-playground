module App exposing (..)

import Html exposing (Html, text, div, img)
import Html.Attributes exposing (src)
import FFI
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Json.Encode exposing (Value)
import Task exposing (Task)


getHtml : String -> Task Value Value
getHtml nodeId =
    FFI.async
        """
        setTimeout(function(){
            try {
                callback(_succeed(window.getHtml(_0)));
            } catch (exception) {
                callback(_fail(exception.message));
            }
        }, 2000);
        """
        [ FFI.asIs nodeId ]


type alias Model =
    { message : String
    , logo : String
    }


init : String -> ( Model, Cmd Msg )
init path =
    ( { message = "Your Elm App is working!", logo = path }, Cmd.none )


type Msg
    = Log
    | GotHtml (Result Value Value)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Log ->
            model ! [ Task.attempt GotHtml (getHtml "root") ]

        GotHtml result ->
            case result of
                Ok response ->
                    let
                        message =
                            response
                                |> Decode.decodeValue Decode.string
                                |> Result.withDefault ""
                    in
                        { model | message = message } ! []

                Err error ->
                    let
                        message =
                            error
                                |> Decode.decodeValue Decode.string
                                |> Result.withDefault ""
                    in
                        { model | message = message } ! []


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
