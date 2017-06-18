module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Task exposing (Task)
import Data.UserStory as UserStory exposing (..)


-- MODEL --


type alias Model =
    { ownLogo : String
    , clients : List Client
    , teams : List Team
    , developers : List Developer
    }


init : Task PageLoadError Model
init =
    Task.succeed
        (Model
            "NoLogo.gif"
            -- Recover list of clients
            [ (Client 1 "Randstad" "lr.gif") ]
            -- Recover list of teams
            []
            -- Recover list of developers
            []
        )



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ viewBanner
        , viewLogo model
        , div [ class "container page" ]
            [ div [ class "row" ]
                [ viewClients model.clients ]
            ]
        ]


viewLogo : Model -> Html Msg
viewLogo m =
    div [] [ img [ width 80, src ("imgs/logos/" ++ m.ownLogo) ] [] ]


viewBanner : Html msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "stonebreaker" ]
            , p [] [ text "you work, I'll take notes" ]
            ]
        ]


viewClients : List Client -> Html Msg
viewClients m =
    div [ class "input-l" ]
        [ label [ for "client" ] [ text "Client" ]
        , select [ name "client", class "form-control" ]
            (List.map
                viewClient
                m
            )
        ]


viewClient : Client -> Html Msg
viewClient c =
    option [ value (toString c.idClient) ] [ text c.name ]



-- UPDATE --


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )
