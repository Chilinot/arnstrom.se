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
    | UpdateBlogPost String (Result Http.Error String)
      -- Will send a GET to the github api.
    | FetchContentlist
    | FetchBlogPostContents BlogDecoder.Post
      -- Open a subpage
    | FindBlogPost String
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


downloadBlogPostCmd : Post -> Cmd Msg
downloadBlogPostCmd post =
    Http.getString (BlogDecoder.root_download_url ++ post.name)
        |> Http.send (UpdateBlogPost post.name)


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    if prev.subpage /= curr.subpage then
        case curr.subpage of
            Index ->
                Nothing

            Post p ->
                builder
                    |> replacePath [ p.name ]
                    |> Just
    else
        Nothing


builder2messages : Builder -> List Msg
builder2messages builder =
    case path builder of
        first :: rest ->
            [ FindBlogPost first ]

        _ ->
            [ FetchContentlist, View Index ]


{-| Retrieve a Post record from a list that matches a post name.
-}
postlocator : List Post -> String -> Maybe Post
postlocator list name =
    List.filter (\x -> x.name == name) list
        |> List.head


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

        FetchBlogPostContents post ->
            ( model, downloadBlogPostCmd post )

        UpdateBlogPost name result ->
            let
                -- Returns a post-list without the matching post.
                removePostFromList : List Post -> String -> List Post
                removePostFromList list name =
                    List.filter (\x -> x.name /= name) list

                content =
                    case result of
                        Ok c ->
                            c

                        Err err ->
                            toString err

                blogpost =
                    case postlocator model.contentlist name of
                        Just p ->
                            { p | contents = Just content }

                        Nothing ->
                            BlogDecoder.Post name (Just "Could not find post!")

                newcontentlist =
                    blogpost :: removePostFromList model.contentlist name
            in
                ( { model | contentlist = newcontentlist, subpage = Post blogpost }, Cmd.none )

        FindBlogPost name ->
            let
                post =
                    postlocator model.contentlist name

                subpage : SubPage
                subpage =
                    case post of
                        Just bp ->
                            Post bp

                        Nothing ->
                            Post <| BlogDecoder.Post "NOT FOUND" (Just "Could not find post you were looking for!")
            in
                ( { model | subpage = subpage }, Cmd.none )

        View subpage ->
            ( { model | subpage = subpage }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        postname2item : Post -> Html Msg
        postname2item post =
            button [ onClick (FetchBlogPostContents post) ] [ text <| extractPostName post ]

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
                    text contents
