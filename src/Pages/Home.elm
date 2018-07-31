module Pages.Home exposing (..)

import Html exposing (Html, text, h3)
import Markdown
import Bootstrap.Grid as Grid


root_url : String
root_url =
    "https://api.github.com/repos/chilinot/blog/contents"


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
