module Main exposing (..)

import Html exposing (..)
import Database.Messages
import Database.Models
import Database.View
import Database.Update


-- MODEL


{-|
  A Node of data
-}
type alias Node a =
    { id : String
    , name : String
    , selected : Bool
    , children : List a
    }


{-|
  Leaf with version
-}
type alias VersionedLeaf =
    { id : String
    , name : String
    , version : Int
    , selected : Bool
    }


{-|
  A sprint is a list of 'VersionedLeaf's [of task type]
-}
type alias Sprint =
    Node VersionedLeaf


{-|
  A project is a list of sprints
-}
type alias Project =
    Node Sprint


{-| The model, with all its bells and whistlers
-}
type alias Model =
    { remoteDatabase : Database.Models.DataRepo
    , configuredRepo : Bool
    , projects : List Project
    }


initModel : Model
initModel =
    Model Database.Models.initModel False []


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- MESSAGES


type Msg
    = NoOp
    | DatabaseMsg Database.Messages.Msg



-- VIEW


view : Model -> Html Msg
view model =
    let
        t =
            Database.View.showRepo model.remoteDatabase model.configuredRepo
    in
        div []
            [ Html.map DatabaseMsg t, showTree model.projects ]


showTree : List Project -> Html Msg
showTree tree =
    div [] []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DatabaseMsg (Database.Messages.NewRepo) ->
            ( { model | configuredRepo = True }, Cmd.none )

        DatabaseMsg submsg ->
            let
                ( repoT, msgT ) =
                    Database.Update.update submsg model.remoteDatabase
            in
                ( { model | remoteDatabase = repoT }, Cmd.map DatabaseMsg msgT )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
