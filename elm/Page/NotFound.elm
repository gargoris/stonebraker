module Page.NotFound exposing (view)

import Html exposing (Html, main_, h1, div, img, text)
import Html.Attributes exposing (class, tabindex, id, src, alt)
import Views.Assets as Assets


-- VIEW --


view : Html msg
view =
    main_ [ id "content", class "container", tabindex -1 ]
        [ h1 [] [ text "Not Found" ]
        , div [ class "row" ]
            [ img [ Assets.src Assets.error, alt "giant laser walrus wreaking havoc" ] [] ]
        ]
