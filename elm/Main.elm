module Main exposing (main)

{-| Entry point to the application.
-}

import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Json.Decode as Decode
import Navigation
import Route exposing (Route)
import Page.Errored as Errored exposing (PageLoadError)
import Page.NotFound as NotFound
import Page.Home as Home
import Page.UserStoryEditor as UsEd
import Views.Page as VPage exposing (ActivePage)


-- import Ports

import Task
import Util exposing ((=>))


-- APP
-- WARNING: this whole file will become unnecessary and go away in Elm 0.19,
-- so avoid putting things in here unless there is no alternative!


type Page
    = NotFound
    | Errored PageLoadError
    | Home Home.Model
    | UserStoryEditor UsEd.Model


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
    | UserStoryEditorLoaded (Result PageLoadError UsEd.Model)
    | HomeMsg Home.Msg
    | UserStoryEditorMsg UsEd.Msg


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
                transition UserStoryEditorLoaded (UsEd.init (Just storyId))

            Just Route.Home ->
                transition HomeLoaded (Home.init)



-- { model | pageState = Loaded (Editor Nothing Editor.initNew) } => Cmd.none
-- Just Route.Home ->
--     transition HomeLoaded (Home.init model.session)


initialPage : Page
initialPage =
    UserStoryEditor (UsEd.empty Nothing)


init : Value -> Navigation.Location -> ( Model, Cmd Msg )
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

            ( UserStoryEditorLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (UserStoryEditor subModel) } => Cmd.none

            ( UserStoryEditorLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( HomeMsg subMsg, Home subModel ) ->
                toPage Home HomeMsg (Home.update) subMsg subModel

            ( UserStoryEditorMsg subMsg, UserStoryEditor subModel ) ->
                toPage UserStoryEditor UserStoryEditorMsg (UsEd.update) subMsg subModel

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
        , subscriptions = (\t -> Sub.none)
        }



-- VIEW --


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            VPage.frame isLoading
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame VPage.Other

            Errored subModel ->
                Errored.view subModel
                    |> frame VPage.Other

            Home subModel ->
                Home.view subModel
                    |> frame VPage.Home
                    |> Html.map HomeMsg

            UserStoryEditor subModel ->
                UsEd.view subModel
                    |> frame VPage.UserStoryEditor
                    |> Html.map UserStoryEditorMsg
