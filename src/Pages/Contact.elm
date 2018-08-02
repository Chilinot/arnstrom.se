module Pages.Contact exposing (..)

import Html exposing (Html, text, h3, div)
import Markdown
import Bootstrap.Grid as Grid
import RouteUrl.Builder exposing (Builder, builder, replacePath)


type alias Model =
    {}


init : Model
init =
    {}


type Msg
    = NoOp


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    Nothing


builder2messages : Builder -> List Msg
builder2messages _ =
    [ NoOp ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            {}


content : Html msg
content =
    Markdown.toHtml [] """
You can contact me using matrix: `@lucasemanuel:matrix.org`
"""


view : Model -> Html msg
view model =
    Grid.row []
        [ Grid.col [] [ content ] ]
