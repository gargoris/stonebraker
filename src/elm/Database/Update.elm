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
update : Msg -> DataModel -> ( DataModel, Cmd Msg )
update msg bigMoodel =
    let
        model =
            bigMoodel.remoteRepo

        inmo =
            case msg of
                NewRepo ->
                    model

                NewUrl url ->
                    { model | url = url }

                NewUser user ->
                    { model | name = user }

                NewPassword pss ->
                    { model | password = pss }

                NewCollection col ->
                    { model | collection = col }
    in
        ( (DataModel inmo bigMoodel.projects bigMoodel.localDatabase), Cmd.none )
