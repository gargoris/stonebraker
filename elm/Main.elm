module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Navigation
import App.Section.Root as Root
import App.Etc.Config exposing (AppConfig)


-- APP


{-| Entry point to the application.
-}
main : Program AppConfig Root.Model Root.Msg
main =
    Navigation.programWithFlags Root.locationChanged
        { init = Root.init
        , view = Root.view
        , update = Root.update
        , subscriptions = Root.subscriptions
        }



-- MODEL


type alias Model =
    Int


model : number
model =
    0



-- UPDATE


type Msg
    = NoOp
    | Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Increment ->
            model + 1



-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib


view : Model -> Html Msg
view model =
    div [ class "container", style [ ( "margin-top", "30px" ), ( "text-align", "center" ) ] ]
        [ -- inline CSS (literal)
          div [ class "row" ]
            [ div [ class "col-xs-12" ]
                [ div [ class "jumbotron" ]
                    [ img [ src "static/img/elm.jpg", style styles.img ] [] -- inline CSS (via var)
                    , p [] [ text ("Elm Webpack Starter") ]
                    , button [ class "btn btn-primary btn-lg", onClick Increment ]
                        [ -- click handler
                          span [ class "glyphicon glyphicon-star" ] [] -- glyphicon
                        , span [] [ text "FTW!" ]
                        ]
                    ]
                ]
            ]
        ]



-- CSS STYLES


styles : { img : List ( String, String ) }
styles =
    { img =
        [ ( "width", "33%" )
        , ( "border", "4px solid #337AB7" )
        ]
    }
