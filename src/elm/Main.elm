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


initDataRepo : DataRepo
initDataRepo =
    DataRepo "Remote repository not configured yet" "" "Not configured"


{-| The model, with all its bells and whistlers
-}
type alias Model =
    { remoteRepo : DataRepo
    , projects : List Project
    }


init : ( Model, Cmd Msg )
init =
    ( Model initDataRepo [], Cmd.none )



-- MESSAGES


type Msg
    = NoOp



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ showRepo model.remoteRepo, showTree model.projects ]


showRepo : DataRepo -> Html Msg
showRepo repo =
    div [] [ h1 [] [ text repo.name ], p [] [ text repo.url ] ]


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
