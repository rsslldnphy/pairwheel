module Calendar exposing (..)

import Html exposing (Html, Attribute, h2, h3, button, div, input, text, ul, li, span)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Random

import RoundRobin
import Shuffle

type alias Model = List String

-- UPDATE

type Msg = Shuffle

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Shuffle ->
      (model, Cmd.none)

-- view

calendarPair : (String, String) -> Html Msg
calendarPair (a, b) = li [] [text (a ++ " & " ++ b)]

calendarColumn : String -> List (String, String) -> Html Msg
calendarColumn day pairs =
  div [ class "day-column col-md-2" ]
    [ h3 [] [text day]
    , ul [class "calendar-list"] (List.map calendarPair pairs)]


view : Model -> Html Msg
view model =
  let names = RoundRobin.ensureEven model
      pairs = RoundRobin.pairs names
      days  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  in div [ class "column-right" ]
      [ h2 [] [ text "Pairs" ]
      , div [ class "row" ] (List.map2 calendarColumn days pairs) ]
