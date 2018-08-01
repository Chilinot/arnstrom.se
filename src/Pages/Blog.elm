module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul)
import Http
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
    = UpdateContentlist (Result Http.Error (List File))
    | FetchContentlist


builder2messages : Builder -> List Msg
builder2messages builder =
    case path builder of
        -- TODO: Implement this to fetch the blogpost in the url
        _ ->
            [ FetchContentlist ]


downloadContentlistCmd : Cmd Msg
downloadContentlistCmd =
    Http.get (BlogDecoder.root_url) BlogDecoder.contentListDecoder
        |> Http.send UpdateContentlist


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
            ( model
            , downloadContentlistCmd
            )


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
