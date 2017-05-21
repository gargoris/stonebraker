module Data.UserStory exposing (UserStoryData, UserStoryId, userStoryIdParser, init)

{-| User Story module for data definition.
Data and more data about user stories.
-}

-- import Json.Decode.Pipeline as Pipeline exposing (decode, required)
-- import Json.Encode.Extra as EncodeExtra
-- import Util exposing ((=>))

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import UrlParser
import Html exposing (Html)
import Date exposing (..)
import Table exposing (..)


type alias Id =
    Int


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    , data : UserStoryData
    }


type alias Client =
    { idClient : Id
    , name : String
    , urlLogo : String
    }



{- You may need something for identify the team in wich the develepor for the story works -}


type alias Team =
    { idTeam : Id
    , name : String
    }



{- The data for the sprint (we use scrum, right?) -}


type alias Sprint =
    { idSprint : Id
    , name : String
    }



{- What's the story, morning glory? -}


type StoryType
    = UserStory
    | HotFix
    | Improvement
    | UserStoryBug



{- A set of changes in the source control version  for the project (TFS, SVN, GIT, they all have a code for a every commit).
   The ID must be a string because every system uses a different approach, usually a short hash string.
-}


type alias ChangeSet =
    { id : String
    , author : String
    , linesCoverBefore : Int
    , linesCoverAfter : Int
    , blocksCoverBefore : Int
    , blocksCoverAfter : Int
    }



{- Data for a test case
   The type for the id is string because we don't know which system is in use in the project for identify every test case.
-}


type alias TestCase =
    { id : String
    , name : String
    , passedDev : Bool
    , passedTest : Bool
    , datePassDev : Date
    , datePassTest : Date
    }



{- A Developer -}


type alias Developer =
    { name : String
    }



{-
   Full description for the main page
-}


ts : Table.State
ts =
    Table.initialSort "Length"


type alias UserStoryData =
    { client : Client
    , team : Team
    , sprint : Sprint
    , id : UserStoryId
    , name : String
    , description : String
    , developer : Developer
    , usType : StoryType
    , listChanges : GhostBox ChangeSet (Table.initialSort "Length")

    --, listTests : GhostBox TestCase
    --, listProposedTests : GhostBox TestCase
    }



{-
   A ghost box is a list of something that can be sorted using sortable tables. We
   also includes here the configuration for the table.
   The code must warranties that the elements of a ghost box always keep sorted using the sorting system.
-}


type alias GhostBox m =    { elements : List m, sortState : Table.State}
    -- , tableConfig : Table.Config


init : UserStoryData
init =
    UserStoryData
        (Client 0 "" "")
        (Team)
        (Sprint)
        0
        ""
        ""
        (Developer)
        UserStory
        (GhostBox ChangeSet Table.Tabl)
        (GhostBox TestCase)
        (GhostBox TestCase)



{-
   UserStory and its parsers
-}


type UserStoryId
    = UserStoryId Int


userStoryIdToString : UserStoryId -> String
userStoryIdToString (UserStoryId id) =
    toString id


userStoryIdParser : UrlParser.Parser (UserStoryId -> a) a
userStoryIdParser =
    UrlParser.custom "USERSTORYID" (Result.map UserStoryId << String.toInt)


userStoryIdDecoder : Decoder UserStoryId
userStoryIdDecoder =
    Decode.map UserStoryId Decode.int


encodeUserStoryId : UserStoryId -> Value
encodeUserStoryId (UserStoryId id) =
    Encode.int id


userStoryIdToHtml : UserStoryId -> Html msg
userStoryIdToHtml id =
    userStoryIdToString id |> Html.text
