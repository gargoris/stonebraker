module Main exposing (..)

import Date exposing (..)


type ProjectType
    = Evolutionary
    | Corrective


type alias Sprint =
    { path : String
    , initDate : Date
    , endDate : Date
    }


type alias Project =
    { name : String
    , projectType : ProjectType
    , sprints : List Sprint
    }
