module Shuffle exposing (shuffle)
import List
import Random
import Trampoline as T

type alias ShuffleState a = (Random.Seed, List a, List a)

shuffle : Random.Seed -> List a -> (List a, Random.Seed)
shuffle seed arr = if List.empty arr then (arr, seed) else
    let helper : ShuffleState a -> T.Trampoline (ShuffleState a)
        helper (s, xs, a) = let (m_val, s', a') = choose s a
            in case m_val of
                Nothing -> T.Done (s, xs, a)
                Just val -> T.Continue (\() -> helper (s', val::xs, a'))
        (seed', shuffled, _) = T.trampoline (helper (seed, [], arr))
    in (Array.fromList shuffled, seed')
