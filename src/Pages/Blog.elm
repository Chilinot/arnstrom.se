module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul)
import Http
import Markdown
import Bootstrap.Grid as Grid
import BlogDecoder exposing (File, filenames2items)
import RouteUrl.Builder exposing (Builder, builder, replacePath, path)


type alias Model =
    { contentlist : List File
    , subpage : SubPage
    }


type SubPage
    = Index
      -- The string should contain some identifier for the post
    | Post String


type Msg
    = UpdateContentlist (Result Http.Error (List File))
    | FetchContentlist
    | View SubPage


init : Model
init =
    { contentlist = []
    , subpage = Index
    }


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

        View subpage ->
            ( { model | subpage = subpage }, Cmd.none )


view : Model -> List (Html msg)
view model =
    let
        index model =
            ul [] <|
                if model.contentlist == [] then
                    [ text "No blog posts loaded." ]
                else
                    filenames2items model.contentlist
    in
        case model.subpage of
            Index ->
                [ Grid.row []
                    [ Grid.col [] [ index model ] ]
                ]

            Post id ->
                [ text "TODO" ]
