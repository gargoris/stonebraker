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
    case repo of
        Just m ->
            div [] [ h1 [] [ text m.name ], p [] [ text m.url ] ]

        Nothing ->
            form
                [ action "javascript:void(0);"
                , onSubmit NewRepo
                ]
                [ h2 [] [ text "New repo" ]
                , div [ class "input-group" ]
                    [ div
                        [ class "input-group" ]
                        [ span
                            [ class "input-group-addon" ]
                            [ i [ class "glyphicon glyphicon-link" ] [] ]
                        , input
                            [ type_ "text"
                            , class "form-control"
                            , placeholder "Url"
                            , size 40
                            , required True
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
                            , class "form-control"
                            , placeholder "User"
                            , size 40
                            , required True
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
                            , class "form-control"
                            , placeholder "Password"
                            , size 40
                            , required True
                            ]
                            []
                        ]
                    , div
                        [ class "col-md-3 col-md-offset-9" ]
                        [ button
                            [ type_ "submit"
                            , class "btn btn-primary"
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
    case msg of
        NoOp ->
            ( model, Cmd.none )

        NewRepo ->
            ( model, Cmd.none )



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
