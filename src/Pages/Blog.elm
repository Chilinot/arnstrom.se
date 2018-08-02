module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul)
import Http
import Markdown
import Bootstrap.Grid as Grid
import BlogDecoder exposing (File, filenames2items)
import RouteUrl.Builder exposing (Builder, builder, replacePath, path)


type alias Model =
    { contentlist : List File }


type Msg
    = UpdateContentlist (Result Http.Error (List File))
    | FetchContentlist


init : Model
init =
    { contentlist = [] }


downloadContentlistCmd : Cmd Msg
downloadContentlistCmd =
    Http.get (BlogDecoder.root_url) BlogDecoder.contentListDecoder
        |> Http.send UpdateContentlist


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    --builder
    --    |> replacePath [ toString curr ]
    --    |> Just
    -- TODO: Implement this to set the selected blogpost in the url
    Nothing


builder2messages : Builder -> List Msg
builder2messages builder =
    case path builder of
        -- TODO: Implement this to fetch the blogpost in the url
        _ ->
            [ FetchContentlist ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateContentlist input ->
            let
                newlist =
                    Result.withDefault [] input
            in
                ( { model | contentlist = newlist }, Cmd.none )

        FetchContentlist ->
            ( model, downloadContentlistCmd )


view : Model -> List (Html msg)
view model =
    let
        content model =
            ul [] <|
                if model.contentlist == [] then
                    [ text "No blog posts loaded." ]
                else
                    filenames2items model.contentlist
    in
        [ Grid.row []
            [ Grid.col [] [ content model ] ]
        ]
