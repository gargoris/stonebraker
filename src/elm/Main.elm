module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (action, class, id, disabled, name, placeholder, property, required, size, src, style, type_, value)
import Html.Events exposing (on, onInput, onClick, onSubmit, targetValue)


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
    | NewRepo
    | NewUrl String
    | NewUser String
    | NewPassword String



-- VIEW


view : Model -> Html Msg
view model =
    let
        t =
            showRepo model.remoteDatabase
    in
        div []
            [ t, showTree model.projects ]


showRepo : Maybe DataRepo -> Html Msg
showRepo repo =
    form
        [ action "javascript:void(0);"
        , onSubmit NewRepo
        ]
        [ h2 [] [ text "New repo" ]
        , div [ class "input-group clearfix" ]
            [ div
                [ class "input-group" ]
                [ span
                    [ class "input-group-addon" ]
                    [ i [ class "glyphicon glyphicon-link" ] [] ]
                , input
                    [ type_ "text"
                    , class "form-control md-col md-col-6"
                    , placeholder "Url"
                    , size 40
                    , required True
                    , onInput NewUrl
                    ]
                    []
                ]
            , div
                [ class "input-group" ]
                [ span
                    [ class "input-group-addon" ]
                    [ i [ class "glyphicon glyphicon-user" ] [] ]
                , input
                    [ type_ "text"
                    , class "form-control md-col md-col-6"
                    , placeholder "User"
                    , size 40
                    , required True
                    , onInput NewUser
                    ]
                    []
                ]
            , div
                [ class "input-group" ]
                [ span
                    [ class "input-group-addon" ]
                    [ i [ class "glyphicon glyphicon-asterisk" ] [] ]
                , input
                    [ type_ "password"
                    , class "form-control md-col md-col-6"
                    , placeholder "Password"
                    , size 40
                    , required True
                    , onInput NewPassword
                    ]
                    []
                ]
            , div
                [ class "col-md-3 col-md-offset-9" ]
                [ button
                    [ type_ "submit"
                    , class "btn btn-primary  md-col md-col-6"
                    , required True
                    ]
                    [ text "Send" ]
                ]
            ]
        ]


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

            NewRepo ->
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
