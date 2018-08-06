module Pages.Blog exposing (..)

import Html exposing (Html, text, h4, ul, li, button, div)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Markdown
import Bootstrap.Grid as Grid


--import Bootstrap.Card as Card
--import Bootstrap.Card.Block as Block
--import Bootstrap.Button as Button

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
        post2item : Post -> Html Msg
        post2item post =
            let
                {- Capitilizes the first letter in a string.
                   Example: capitilizeFirst "foobar" -> "Foobar"
                -}
                capitilizeFirst : String -> String
                capitilizeFirst string =
                    String.toUpper (String.left 1 string) ++ String.dropLeft 1 string

                {- Replaces all '_' with a space.
                   Example: replaceUnderscores "asdf_foobar" -> "asdf foobar"
                -}
                replaceUnderscores : String -> String
                replaceUnderscores string =
                    String.split "_" string
                        |> String.join " "

                title =
                    extractPostName post
                        |> replaceUnderscores
                        |> capitilizeFirst
                        |> text
            in
                Grid.row []
                    --[ Grid.col []
                    --    [ Card.config []
                    --        |> Card.block []
                    --            [ Block.titleH4 [] [ text (extractPostName post) ]
                    --            , Block.link [ href ("#!/blog/" ++ post.name) ] [ text "Open" ]
                    --            ]
                    --        |> Card.view
                    --    ]
                    --]
                    [ Grid.col []
                        [ h4 [] [ title ] ]
                    ]

        index : Model -> List (Html Msg)
        index model =
            if model.contentlist == [] then
                [ Grid.row []
                    [ Grid.col []
                        [ text "No blog posts loaded." ]
                    ]
                ]
            else
                List.map post2item model.contentlist
    in
        case model.subpage of
            Index ->
                div [] <| index model

            Post post ->
                let
                    contents =
                        Maybe.withDefault "No contents!" post.contents
                in
                    Grid.row []
                        [ Grid.col []
                            [ Markdown.toHtml [] contents ]
                        ]
