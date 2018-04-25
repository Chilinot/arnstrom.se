module Pages.Home exposing (..)

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
This will someday in the future contain my blog. Currently there is not much here.
"""


view : Model -> List (Html msg)
view model =
    [ Grid.row []
        [ Grid.col [] [ content ] ]
    ]
