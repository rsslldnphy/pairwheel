port module Pairwheel exposing (main)

import Html exposing (Html, Attribute, h1, button, div, input, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Random

import Calendar
import TeamList

main =
  Html.programWithFlags
    { view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    , init = init}

type alias Model =
  { teamList : TeamList.Model
  }

-- UPDATE

type Msg
  = TeamListEvent TeamList.Msg
  | CalendarEvent Calendar.Msg

port setStorage : Model -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    TeamListEvent msg -> let (teamList, cmd) = TeamList.update msg model.teamList
                             newModel        = {model | teamList = teamList}
                         in (newModel, Cmd.batch [Cmd.map TeamListEvent cmd, setStorage newModel])
    CalendarEvent msg -> (model, Cmd.none)

-- view

view : Model -> Html Msg
view model =
  div []
    [
      div [ class "col-md-3" ] [ Html.map (\msg -> TeamListEvent msg) (TeamList.view model.teamList) ]
    , div [ class "col-md-9" ] [ Html.map (\msg -> CalendarEvent msg) (Calendar.view (List.map .name model.teamList.teamMembers)) ]
    ]

-- init

init : Maybe Model -> (Model, Cmd Msg)
init model =
    case model of
      Nothing -> let (teamList, cmd) = TeamList.init in ({teamList = teamList}, Cmd.map TeamListEvent cmd)
      Just model -> (model, Cmd.none)
