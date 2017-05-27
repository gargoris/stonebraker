module Main exposing (main)

{-| Entry point to the application.
-}

import Json.Decode as Decode exposing (Value)
import Navigation
import Task
import Util exposing ((=>))
import Route exposing (Route)
import Json.Decode as Decode
import Navigation exposing (Location)
import Route exposing (Route)
import Views.Page as Page exposing (ActivePage)
import Page.Errored as Errored exposing (PageLoadError)
import Page.Home as Home
import Page.UserStoryEditor as UserStoryEditor


-- import Ports

import Task
import Util exposing ((=>))
import Route exposing (Route)
import Json.Decode as Decode
import Html exposing (..)
import Route exposing (Route)
import Html
import Data.UserStory as UserStory exposing (..)


-- APP
-- WARNING: this whole file will become unnecessary and go away in Elm 0.19,
-- so avoid putting things in here unless there is no alternative!


type Page
    = NotFound
    | Errored PageLoadError
    | Home Home.Model
    | UserStoryEditor UserStoryId


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { --session : Session,
      pageState : PageState
    }


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | HomeMsg Home.Msg
    | UserStoryEditorMsg UserStoryEditor.Msg


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        { model | pageState = Loaded (Errored error) } => Cmd.none


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model.pageState) }
                => Task.attempt toMsg task

        errored =
            pageErrored model
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFound } => Cmd.none

            Just (Route.UserStoryEditor storyId) ->
                { model | pageState = Loaded NotFound } => Cmd.none

            -- { model | pageState = Loaded (Editor Nothing Editor.initNew) } => Cmd.none
            Just Route.Home ->
                transition HomeLoaded (Home.init model.session)


initialPage : Page
initialPage =
    Home


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        session =
            model.session

        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( HomeLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (Home subModel) } => Cmd.none

            ( HomeLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( HomeMsg subMsg, Home subModel ) ->
                toPage Home HomeMsg (Home.update session) subMsg subModel

            ( UserStoryEditorMsg subMsg, UserStoryEditor subModel ) ->
                toPage UserStoryEditor UserStoryEditorMsg (UserStoryEditor.update) subMsg subModel

            ( ArticleMsg subMsg, Article subModel ) ->
                toPage Article ArticleMsg (Article.update model.session) subMsg subModel

            ( EditorMsg subMsg, Editor slug subModel ) ->
                case model.session.user of
                    Nothing ->
                        if slug == Nothing then
                            errored Page.NewArticle
                                "You must be signed in to post articles."
                        else
                            errored Page.Other
                                "You must be signed in to edit articles."

                    Just user ->
                        toPage (Editor slug) EditorMsg (Editor.update user) subMsg subModel

            ( _, NotFound ) ->
                -- Disregard incoming messages when we're on the
                -- NotFound page.
                model => Cmd.none

            ( _, _ ) ->
                -- Disregard incoming messages that arrived for the wrong page
                model => Cmd.none


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
