module Database.Models exposing (..)

import Pouchdb exposing (Pouchdb, auth, ajaxCache, dbOptions, db)
import Change exposing (..)
import Replicate exposing (..)


{-|
 Models for database definition => config, inner workings, etc.
-}



-- DEFINITIONS


type alias DataModel =
    { remoteRepo : DataRepo
    , projects : List Project
    , localDatabase : Pouchdb
    }


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


initModel : DataModel
initModel =
    DataModel (DataRepo "" "" "" "") [] checkDB


checkDB : Pouchdb
checkDB =
    db "Stonebreaker" (dbOptions)
