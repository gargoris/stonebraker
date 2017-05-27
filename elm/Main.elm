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
    = Blank
    | NotFound
    | TaskEditor UserStoryData


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { --session : Session,
      pageState : PageState
    }


type Msg
    = SetRoute (Maybe Route)


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        { model | pageState = Loaded (Errored error) } => Cmd.none


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

            Just Route.NewArticle ->
                case model.session.user of
                    Just user ->
                        { model | pageState = Loaded (Editor Nothing Editor.initNew) } => Cmd.none

                    Nothing ->
                        errored Page.NewArticle "You must be signed in to post an article."

            Just (Route.EditArticle slug) ->
                case model.session.user of
                    Just user ->
                        transition (EditArticleLoaded slug) (Editor.initEdit model.session slug)

                    Nothing ->
                        errored Page.Other "You must be signed in to edit an article."

            Just Route.Settings ->
                case model.session.user of
                    Just user ->
                        { model | pageState = Loaded (Settings (Settings.init user)) } => Cmd.none

                    Nothing ->
                        errored Page.Settings "You must be signed in to access your settings."

            Just Route.Home ->
                transition HomeLoaded (Home.init model.session)

            Just Route.Login ->
                { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none

            Just Route.Logout ->
                let
                    session =
                        model.session
                in
                    { model | session = { session | user = Nothing } }
                        => Cmd.batch
                            [ Ports.storeSession Nothing
                            , Route.modifyUrl Route.Home
                            ]

            Just Route.Register ->
                { model | pageState = Loaded (Register Register.initialModel) } => Cmd.none

            Just (Route.Profile username) ->
                transition (ProfileLoaded username) (Profile.init model.session username)

            Just (Route.Article slug) ->
                transition ArticleLoaded (Article.init model.session slug)


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage
        , session = { user = decodeUserFromJson val }
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( msg, None )


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
