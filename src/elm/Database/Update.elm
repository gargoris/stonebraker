module Database.Update exposing (..)

import Database.Messages exposing (..)
import Database.Modes exposing(..)
import Database.View exposing(..)
{-|
    Update for this module
-}


-- DEFINITIONS
{-|
    Main update function
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
case msg of
  
