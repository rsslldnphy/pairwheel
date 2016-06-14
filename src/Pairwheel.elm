module Pairwheel exposing (main)

import Html exposing (Html, Attribute, h1, button, div, input, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Random

import Calendar
import TeamList

main =
  Html.program
    { view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , init = init}

type alias Model =
  { dieFace : Int
  , teamMembers : TeamList.Model
  }

-- UPDATE

type Msg
  = Roll
  | NewFace Int
  | TeamListEvent TeamList.Msg
  | CalendarEvent Calendar.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll              -> (model, Cmd.none)
    NewFace n         -> (model, Cmd.none)
    TeamListEvent msg -> let (teamMembers, cmd) = TeamList.update msg model.teamMembers
                         in ({model | teamMembers = teamMembers}, Cmd.map TeamListEvent cmd)
    CalendarEvent msg -> (model, Cmd.none)

-- view

view : Model -> Html Msg
view model =
  div []
    [
      div [ class "col-md-3" ] [ Html.map (\msg -> TeamListEvent msg) (TeamList.view model.teamMembers) ]
    , div [ class "col-md-9" ] [ Html.map (\msg -> CalendarEvent msg) (Calendar.view []) ]
    ]

-- init

init : (Model, Cmd Msg)
init =
    let (teamMembers, cmd) = TeamList.init
    in ({dieFace = 7,  teamMembers = teamMembers}, Cmd.map TeamListEvent cmd)
