module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul)
import Markdown
import Bootstrap.Grid as Grid
import BlogDecoder exposing (File, filenames2items)
import RouteUrl.Builder exposing (Builder, builder, replacePath, path)


type alias Model =
    { contentlist : List File }


init : Model
init =
    { contentlist = [] }


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    --builder
    --    |> replacePath [ toString curr ]
    --    |> Just
    Nothing


type Msg
    = UpdateContentlist (List File)


builder2messages : Builder -> List Msg
builder2messages builder =
    case path builder of
        -- TODO: Implement this to fetch the blogpost in the url
        _ ->
            -- If URL is empty, update contentlist
            let
                contentlist =
                    BlogDecoder.contentListDecoder BlogDecoder.test_data
            in
                [ UpdateContentlist contentlist ]


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
