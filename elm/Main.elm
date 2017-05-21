module Main exposing (..)

{-| Entry point to the application.
-}

import Navigation
import Data.MainData exposing (..)


-- APP


initLocal : MainData
initLocal =
    MainData
        (Client 0 "" "")
        (Team)
        (Sprint)
        0
        ""
        ""
        (Developer)
        UserStory
        (GhostBox ChangeSet)
        (GhostBox TestCase)
        (GhostBox TestCase)


main : Program AppConfig Root.Model Root.Msg
main =
    Navigation.programWithFlags Root.locationChanged
        { init = Root.init
        , view = Root.view
        , update = Root.update
        , subscriptions = Root.subscriptions
        }
