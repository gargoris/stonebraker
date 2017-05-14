module App.Page.Inner.Data exposing (..)


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    , data : MainData
    }


type alias Client =
    { idClient : Int
    , name : String
    , urlLogo : String
    }


type alias Team =
    { idTeam : Int
    , name : String
    }


type alias Sprint =
    { idSprint : Int
    , name : String
    }


type StoryType
    = UserStory
    | HotFix
    | Improvement
    | UserStoryBug


type alias ChangeSet =
    { id : Int
    , author : String
    , linesCoverBefore : Int
    , linesCoverAfter : Int
    , blocksCoverBefore : Int
    , blocksCoverAfter : Int
    }


type alias TestCase =
    { id : Int
    , name : String
    , passedDev : Bool
    , passedTest : Bool
    , datePassDev : Date
    , datePassTest : Date
    }


type alias Developer =
    { name : String
    }


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
