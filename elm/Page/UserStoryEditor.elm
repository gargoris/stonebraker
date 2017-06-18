module Page.UserStoryEditor
    exposing
        ( view
        , update
        , Model
        , Msg
        , empty
        , init
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Data.UserStory as UserStory exposing (..)
import Task exposing (Task)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)


type alias Model =
    UserStoryData



-- Init empty --


init : Maybe UserStoryId -> Task PageLoadError Model
init m =
    Task.succeed (empty m)


empty : Maybe UserStoryId -> Model
empty id =
    case id of
        Just m ->
            UserStory.init m

        Nothing ->
            UserStory.initEmpty



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "userStory-page" ]
        [ div [ class "userStory-data" ]
            [ div [ class "userStory-head" ]
                -- User Story data: id, name and description
                [ viewMainData model ]
            , div [ class "userStory-dev" ]
                -- User Story dev: developer, date
                [ viewDevData model ]
            , div [ class "userStory-changes" ]
                -- User story changes
                [ viewChanges model
                ]
            , div [ class "userStory-tests" ]
                -- User story changes
                [ viewTestCases model
                ]
            ]
        ]



{--
View Functions
-}


viewMainData : Model -> Html Msg
viewMainData m =
    div [] []


viewDevData : Model -> Html Msg
viewDevData m =
    div [] []


viewChanges : Model -> Html Msg
viewChanges m =
    div [] []


viewTestCases : Model -> Html Msg
viewTestCases m =
    div [] []


type Msg
    = None



-- | NewTestCase
-- | NewChangeSet
-- | RemoveChangeSet ChangeSetId
-- | RemoveTestCase TestCaseId
-- | SaveStory
-- Update --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )
