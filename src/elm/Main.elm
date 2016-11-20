module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (action, class, id, disabled, name, placeholder, property, required, size, src, style, type_, value)
import Html.Events exposing (on, onInput, onClick, onSubmit, targetValue)
import Database.Messages
import Database.Models
import Database.View


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
            [ t, showTree model.projects ]


showTree : List Project -> Html Msg
showTree tree =
    div [] []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newBaseModel =
            case model.remoteDatabase of
                Just innerMod ->
                    innerMod

                Nothing ->
                    DataRepo "" "" ""

        baseList =
            model.projects
    in
        case msg of
            NoOp ->
                ( model, Cmd.none )

            DatabaseMsg submsg ->
                ( model, Cmd.none )

            NewUrl m ->
                ( (Model (Just { newBaseModel | url = m }) baseList), Cmd.none )

            NewUser m ->
                ( (Model (Just { newBaseModel | name = m }) baseList), Cmd.none )

            NewPassword m ->
                ( (Model (Just { newBaseModel | password = m }) baseList), Cmd.none )



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
