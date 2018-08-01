module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul)
import Markdown
import Bootstrap.Grid as Grid
import BlogDecoder exposing (File, filenames2items)


type alias Model =
    { contentlist : List File }


init : Model
init =
    { contentlist = [] }


type Msg
    = UpdateContentlist (List File)


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateContentlist newlist ->
            { model | contentlist = newlist }


content : Model -> Html msg
content model =
    ul [] <|
        if model.contentlist == [] then
            [ text "No blog posts loaded." ]
        else
            filenames2items model.contentlist


view : Model -> List (Html msg)
view model =
    [ Grid.row []
        [ Grid.col [] [ content model ] ]
    ]
