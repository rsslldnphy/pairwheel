module RoundRobin exposing (..)

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
ensureEven team = if List.length team `rem` 2 == 0 then team else team ++ ["_"]
