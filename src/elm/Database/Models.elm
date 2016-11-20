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
    }


initModel : DataRepo
initModel =
    DataRepo "" "" ""
