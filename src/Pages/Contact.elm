module Pages.Contact exposing (..)

import Html exposing (Html, text, h3)
import Markdown
import Bootstrap.Grid as Grid


type alias Model =
    {}


init : Model
init =
    {}


content : Html msg
content =
    Markdown.toHtml [] """
You can contact me using matrix: `@lucasemanuel:matrix.org`
"""


view : Model -> List (Html msg)
view model =
    [ Grid.row []
        [ Grid.col [] [ content ] ]
    ]
