module Main exposing (..)

import Html exposing (..)
import Html.App


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


{-| The repository data
-}
type alias DataRepo =
    { name : String
    , password : String
    , url : String
    }


{-| The model, with all its bells and whistlers
-}
type alias Model =
    { remoteDatabase : Maybe DataRepo
    , projects : List Project
    }


initModel : Model
initModel =
    Model Nothing []


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- MESSAGES


type Msg
    = NoOp



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ showRepo model.remoteDatabase, showTree model.projects ]


showRepo : Maybe DataRepo -> Html Msg
showRepo repo =
    case repo of
        Just m ->
            div [] [ h1 [] [ text m.name ], p [] [ text m.url ] ]

        Nothing ->
            div [] [ h1 [] [ text "Repository not configured" ], p [] [ text "Empty url" ] ]


showTree : List Project -> Html Msg
showTree tree =
    div [] []



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
