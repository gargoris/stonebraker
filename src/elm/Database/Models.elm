module Database.Models exposing (..)

{-|
 Models for database definition => config, inner workings, etc.
-}

-- DEFINITIONS


{-|
 A remote repository configuration
-}
type alias DataRepo =
    { name : String
    , password : String
    , url : String
    , collection : String
    }


type alias Project =
    { area_name : String
    , sprints : List Sprint
    }


type alias Sprint =
    { sprint_name : String
    , users : List User
    }


type alias User =
    { user_name : String
    , software_projects : List Sftprojs
    }


type alias Sftprojs =
    {}


initModel : DataRepo
initModel =
    DataRepo "" "" "" ""
