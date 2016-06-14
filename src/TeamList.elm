module TeamList exposing (..)

import Html exposing (Html, Attribute, h2, button, div, input, text, ul, li, i, span)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Random

type alias UID = Int

type alias TeamMember =
  { name : String
  , uid : UID
  }

type alias Model =
  { teamMembers : List TeamMember
  , nextUid : UID
  }

-- UPDATE

type Msg = Add | Update UID String | Delete UID

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Add             -> (addTeamMember model, Cmd.none)
    Update uid name -> (updateTeamMember model uid name, Cmd.none)
    Delete uid      -> (deleteTeamMember model uid, Cmd.none)

addTeamMember : Model -> Model
addTeamMember model =
  let newMember = TeamMember "" model.nextUid
  in { model | teamMembers = model.teamMembers ++ [newMember], nextUid = model.nextUid + 1 }

deleteTeamMember : Model -> UID -> Model
deleteTeamMember model uid =
  { model | teamMembers = List.filter (\m -> m.uid /= uid ) model.teamMembers }

updateTeamMember : Model -> UID -> String -> Model
updateTeamMember model uid name =
  { model | teamMembers = List.map (\m -> if m.uid == uid then {m | name = name} else m) model.teamMembers }

-- view

view : Model -> Html Msg
view model =
  div [ class "column-left" ]
    [ div [class "btn-toolbar pull-right"]
    [ div [class "btn-group"] [ button [class "btn btn-success", onClick Add ] [i [class "fa fa-plus"] []]]]
    , h2 [] [text "Team members"]
    , ul [class "team-member-list"] (List.map teamMemberInput model.teamMembers)
    , div [] (List.map (\ps -> text (toString ps)) (pairs (ensureEven (List.map .name model.teamMembers))))
    ]

teamMemberInput : TeamMember -> Html Msg
teamMemberInput {name, uid} =
  li []
    [ div [class "input-group"]
    [ input [type' "text", value name, class "form-control", onInput (Update uid)] []
    , span [ class "input-group-btn" ]
    [ button [class "btn btn-danger", onClick (Delete uid)] [i [class "fa fa-trash"] []]]]]

-- init

init : (Model, Cmd Msg)
init =
  ({teamMembers = [{uid = 0, name = "russell"}], nextUid = 1}, Cmd.none)


rotate : List a -> List a
rotate team =
  case team of []              -> [ ]
               a :: []         -> [a]
               a :: b :: team  -> [a] ++ team ++ [b]

pair : List a -> List (a, a)
pair team =
  let n      = List.length team // 2
      top    = List.take n team
      bottom = List.reverse (List.drop n team)
  in
      List.map2 (,) top bottom

pairs : List a -> List (List (a, a))
pairs team =
  List.scanl (\_ t -> rotate t) team [1..4] |> List.map pair

ensureEven : List String -> List String
ensureEven team = if List.length team `rem` 2 == 0 then team else team ++ ["-"]

-- (defn pair
--   [team]
--   (-> (split-at (/ (count team) 2) team)
--       (update 1 reverse)
--       (->> (apply map vector))))

-- (doseq [p (take 5 (map pair (iterate rotate team)))]
--   (println p))
