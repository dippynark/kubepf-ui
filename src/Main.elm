port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http

import Json.Decode as Json

import WebSocket

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- Model

type alias Model =
    { cast : String
    , casts : List String
    }
    
init : (Model, Cmd Msg)
init =
    ( Model "" ["1", "2"], Cmd.none )

-- Messages	

type Msg
    = DisplayCast String
    | ListCasts String

-- Update

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DisplayCast cast ->
            ( { model | cast = cast }, displayCast cast )
        ListCasts casts ->
            ( { model | casts = String.split "\n" casts}, Cmd.none )

-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen "ws://192.168.1.27:5050/list" ListCasts

-- View
 
castOption cast =
    option [ value (toString cast) ] [ text (toString cast) ]

view : Model -> Html Msg
view model =
    div [ class "container" ] [
        div [ class "row" ] [
            h2 [ class "text-center" ] [ text "Terminal Sessions" ]
            , select [ onInput DisplayCast ]
                (List.map castOption model.casts)
        ], div [class "row" ] [
            p [ class "row" ] [ text model.cast ]
        ]
    ]

-- Ports

port displayCast : String -> Cmd msg
