module Calendar exposing (..)

import Html exposing (Html, Attribute, h2, h3, button, div, input, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Random

type alias Model = List Int

-- UPDATE

type Msg = Roll | NewFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))
    NewFace n ->
      ([n], Cmd.none)

-- view

view : Model -> Html Msg
view model =
  div [ class "column-right" ]
    [ h2 [] [ text "Pairs" ]
    , div [ class "row" ]
    [ div [ class "day-column col-md-2" ] [h3 [] [text "Monday"]]
    , div [ class "day-column col-md-2" ] [h3 [] [text "Tuesday"]]
    , div [ class "day-column col-md-2" ] [h3 [] [text "Wednesday"]]
    , div [ class "day-column col-md-2" ] [h3 [] [text "Thursday"]]
    , div [ class "day-column col-md-2" ] [h3 [] [text "Friday"]]
    ]]

-- init

init : (Model, Cmd Msg)
init =
  ([7], Cmd.none)
