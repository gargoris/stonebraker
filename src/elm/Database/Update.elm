module Database.Update exposing (..)

{-|
    Update for this module
-}

import Pouchdb exposing (Pouchdb, auth, ajaxCache, dbOptions, db)
import Change exposing (..)
import Replicate exposing (..)
import Database.Messages exposing (..)
import Database.Models exposing (..)


-- DEFINITIONS


{-|
    Main update function
-}
update : Msg -> DataRepo -> ( DataRepo, Cmd Msg )
update msg model =
    case msg of
        NewRepo ->
            ( model, Cmd.none )

        NewUrl url ->
            ( { model | url = url }, Cmd.none )

        NewUser user ->
            ( { model | name = user }, Cmd.none )

        NewPassword pss ->
            ( { model | password = pss }, Cmd.none )

        NewCollection col ->
            ( { model | collection = col }, Cmd.none )
