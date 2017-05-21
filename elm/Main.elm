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
    = None


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
