module Page.Home exposing (view, update, Model, Msg, init)

{-| The homepage. You can get here via either the / or /#/ routes.
-}

import Html exposing (..)
import Html.Attributes exposing (class, href, id, placeholder, attribute, classList)
import Page.Errored as Errored exposing (PageLoadError, pageLoadError)
import Task exposing (Task)


-- MODEL --


type alias Model =
    {}


init : Task PageLoadError Model
init =
    Task.succeed Model



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "home-page" ]
        [ viewBanner
        , div [ class "container page" ]
            [ div [ class "row" ]
                []
            ]
        ]


viewBanner : Html msg
viewBanner =
    div [ class "banner" ]
        [ div [ class "container" ]
            [ h1 [ class "logo-font" ] [ text "conduit" ]
            , p [] [ text "A place to share your knowledge." ]
            ]
        ]



-- UPDATE --


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )
