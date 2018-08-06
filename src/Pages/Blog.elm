module Pages.Blog exposing (..)

import Html exposing (Html, text, h3, ul, li, button, div)
import Html.Attributes
import Html.Events exposing (onClick)
import Http
import Markdown
import Bootstrap.Grid as Grid
import BlogDecoder exposing (Post, File, extractPostName)
import RouteUrl.Builder exposing (Builder, builder, replacePath, path)
import Maybe.Extra


type alias Model =
    { contentlist : List Post
    , subpage : SubPage
    }


type SubPage
    = Index
    | Post BlogDecoder.Post


type Msg
    = UpdateContentlist (Result Http.Error (List File))
    | FetchContentlist
    | FetchPost String
    | OpenPost String (Result Http.Error String)
    | View SubPage


init : Model
init =
    { contentlist = []
    , subpage = Index
    }


downloadContentlistCmd : Cmd Msg
downloadContentlistCmd =
    Http.get (BlogDecoder.root_contents_url) BlogDecoder.contentListDecoder
        |> Http.send UpdateContentlist


downloadBlogPostCmd : String -> Cmd Msg
downloadBlogPostCmd name =
    Http.getString (BlogDecoder.root_download_url ++ name)
        |> Http.send (OpenPost name)


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    case curr.subpage of
        Index ->
            builder
                |> replacePath []
                |> Just

        Post p ->
            builder
                |> replacePath [ p.name ]
                |> Just


builder2messages : Builder -> List Msg
builder2messages builder =
    case path builder of
        first :: rest ->
            [ FetchPost first ]

        _ ->
            [ FetchContentlist, View Index ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateContentlist input ->
            let
                -- Extract the contents of the GET result.
                inputlist =
                    Result.withDefault [] input

                -- Convert the returned files to Post records.
                newlist =
                    List.map BlogDecoder.file2post inputlist
                        |> Maybe.Extra.values
            in
                ( { model | contentlist = newlist }, Cmd.none )

        FetchContentlist ->
            ( model, downloadContentlistCmd )

        FetchPost name ->
            ( model, downloadBlogPostCmd name )

        OpenPost name result ->
            let
                contents =
                    Result.withDefault "POST NOT FOUND!" result

                post =
                    BlogDecoder.Post name (Just contents)
            in
                ( { model | subpage = Post post }, Cmd.none )

        View subpage ->
            ( { model | subpage = subpage }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        postname2item : Post -> Html Msg
        postname2item post =
            button [ onClick (FetchPost post.name) ] [ text <| extractPostName post ]

        postnames2items : List Post -> List (Html Msg)
        postnames2items postlist =
            List.map postname2item postlist

        index : Model -> Html Msg
        index model =
            ul [] <|
                if model.contentlist == [] then
                    [ text "No blog posts loaded." ]
                else
                    postnames2items model.contentlist
    in
        case model.subpage of
            Index ->
                Grid.row []
                    [ Grid.col [] [ index model ] ]

            Post post ->
                let
                    contents =
                        case post.contents of
                            Just c ->
                                c

                            Nothing ->
                                "No contents!"
                in
                    Grid.row []
                        [ Grid.col []
                            [ Markdown.toHtml [] contents ]
                        ]
