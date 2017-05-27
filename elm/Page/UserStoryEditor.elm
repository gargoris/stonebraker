module Page.UserStoryEditor
    exposing
        ( view
        , update
        , Model
        , Msg
        , init
        )

import Data.UserStory as UserStory exposing (..)


type Msg
    = None


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    , data : UserStoryData
    }
