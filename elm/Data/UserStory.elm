module Data.UserStory
    exposing
        ( UserStoryData
        , UserStoryId
        , userStoryIdParser
        )

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
    = Empty
    | UserStory
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


type TestCaseOrigin
    = Defined
    | Proposed


type alias TestCase =
    { id : String
    , name : String
    , passedDev : Bool
    , passedTest : Bool
    , datePassDev : Date
    , datePassTest : Date
    , orig : TestCaseOrigin
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
    { client : Maybe Client
    , team : Maybe Team
    , sprint : Maybe Sprint
    , id : Maybe UserStoryId
    , name : String
    , description : String
    , date : Maybe Date
    , developer : Maybe Developer
    , usType : StoryType
    , listChanges : GhostBox ChangeSet
    , listTests : GhostBox TestCase
    }



{-
   A ghost box is a list of something that can be sorted using sortable tables. We
   also includes here the configuration for the table.
   The code must warranties that the elements of a ghost box always keep sorted using the sorting system.
-}


type alias GhostBox m =
    { elements : List m
    , sortState : Table.State
    }



-- , tableConfig : Table.Config
{-
   UserStory and its parsers
-}


type UserStoryId
    = UserStoryId Int


init : UserStoryData
init =
    UserStoryData
        --client
        Nothing
        --team
        Nothing
        --sprint
        Nothing
        --id
        Nothing
        --name
        ""
        --description
        ""
        --date
        Nothing
        --developer
        Nothing
        --userStoryType
        Empty
        --GhostBox Changesets
        (GhostBox [] (Table.initialSort "Id"))
        --GhostBox TestCases
        (GhostBox [] (Table.initialSort "Id"))


userStoryIdToString : UserStoryId -> String
userStoryIdToString id =
    toString id


userStoryIdParser : UrlParser.Parser (UserStoryId -> a) a
userStoryIdParser =
    UrlParser.custom "USERSTORYID" (Result.map UserStoryId << String.toInt)


userStoryIdDecoder : Decoder UserStoryId
userStoryIdDecoder =
    Decode.map UserStoryId Decode.int


encodeUserStoryId : UserStoryId -> Value
encodeUserStoryId (UserStoryId m) =
    Encode.int m


userStoryIdToHtml : UserStoryId -> Html msg
userStoryIdToHtml id =
    userStoryIdToString id |> Html.text
