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
import Html.Attributes exposing (class, href, id, placeholder, attribute, disabled)
import Data.UserStory as UserStory exposing (..)
import Task exposing (Task)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    , data : UserStoryData
    }



-- Init empty --


init : Task PageLoadError Model
init =
    Task.succeed empty


empty : Model
empty =
    Model
        "NoLogo.gif"
        []
        []
        []
        UserStory.init



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "userStory-page" ]
        [ viewLogo model
        , div [ class "userStory-data" ]
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


viewLogo : Model -> Html Msg
viewLogo m =
    div [] []


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
