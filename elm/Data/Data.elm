module App.Page.Inner.Data exposing (..)


type alias Id =
    Int


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    , data : MainData
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


type alias MainData =
    { client : Client
    , team : Team
    , sprint : Sprint
    , id : Int
    , name : String
    , description : String
    , developer : Developer
    , usType : StoryType
    , listChanges : List ChangeSet
    , listTests : List TestCase
    , listProposedTests : List TestCase
    }



{- A ghost box is a list of something that can be sorted using one o more parts of said something.
   The code must warranties that the elements of a ghost box always keep sorted using the sorting system.
-}


type alias GhostBox m n =
    { elements : List m
    , sortingSystem : List n
    }
