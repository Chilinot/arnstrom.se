module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (href)
import Navigation exposing (Location)
import Color
import UrlParser
import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Pages.Blog as Blog
import Pages.About as About
import Pages.PublicKeys as PublicKeys
import Pages.Contact as Contact
import RouteUrl exposing (RouteUrlProgram, UrlChange)
import RouteUrl.Builder as Builder exposing (Builder)


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = delta2hash
        , location2messages = hash2messages
        , init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- ROUTING


type Page
    = Blog
    | About
    | PublicKeys
    | Contact


delta2hash : Model -> Model -> Maybe UrlChange
delta2hash prev curr =
    Maybe.map Builder.toHashChange <| delta2builder prev curr


delta2builder : Model -> Model -> Maybe Builder
delta2builder prev curr =
    case curr.current_page of
        Blog ->
            Blog.delta2builder prev.blog curr.blog
                |> Maybe.map (Builder.prependToPath [ "blog" ])

        About ->
            About.delta2builder prev.about curr.about
                |> Maybe.map (Builder.prependToPath [ "about" ])

        PublicKeys ->
            PublicKeys.delta2builder prev.about curr.about
                |> Maybe.map (Builder.prependToPath [ "public_keys" ])

        Contact ->
            Contact.delta2builder prev.contact curr.contact
                |> Maybe.map (Builder.prependToPath [ "contact" ])


hash2messages : Location -> List Msg
hash2messages location =
    builder2messages (Builder.fromHash location.href)


builder2messages : Builder -> List Msg
builder2messages builder =
    case Builder.path builder of
        first :: rest ->
            let
                subBuilder =
                    Builder.replacePath rest builder
            in
                case first of
                    "blog" ->
                        (GoTo Blog) :: List.map BlogMsg (Blog.builder2messages subBuilder)

                    "about" ->
                        (GoTo About) :: List.map AboutMsg (About.builder2messages subBuilder)

                    "public_keys" ->
                        (GoTo PublicKeys) :: List.map PublicKeysMsg (PublicKeys.builder2messages subBuilder)

                    "contact" ->
                        (GoTo Contact) :: List.map ContactMsg (Contact.builder2messages subBuilder)

                    _ ->
                        [ GoTo Blog ]

        _ ->
            [ GoTo Blog ]



-- MODEL


type alias Model =
    { current_page : Page
    , nav_state : Navbar.State
    , blog : Blog.Model
    , about : About.Model
    , public_keys : PublicKeys.Model
    , contact : Contact.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( nav_state, nav_cmd ) =
            Navbar.initialState NavMsg
    in
        ( { current_page = Blog
          , nav_state = nav_state
          , blog = Blog.init
          , about = About.init
          , public_keys = PublicKeys.init
          , contact = Contact.init
          }
        , Cmd.batch [ nav_cmd, Cmd.map BlogMsg <| Blog.downloadContentlistCmd ]
        )



-- VIEW


view : Model -> Html Msg
view model =
    let
        navbar model =
            Navbar.config NavMsg
                |> Navbar.container
                |> Navbar.lightCustom Color.white
                |> Navbar.brand [ href "#!/blog" ] [ h2 [] [ text "Lucas Arnström" ] ]
                |> Navbar.items
                    [ Navbar.itemLink [ href "#!/about" ] [ text "About" ]
                    , Navbar.itemLink [ href "#!/public_keys" ] [ text "Public Keys" ]
                    , Navbar.itemLink [ href "#!/contact" ] [ text "Contact" ]
                    ]
                |> Navbar.view model.nav_state

        page model =
            Grid.container [] <|
                case model.current_page of
                    Blog ->
                        Blog.view model.blog

                    About ->
                        About.view model.about

                    PublicKeys ->
                        PublicKeys.view model.public_keys

                    Contact ->
                        Contact.view model.contact
    in
        div []
            [ navbar model
            , page model
            ]



-- UPDATE


type Msg
    = GoTo Page
    | BlogMsg Blog.Msg
    | AboutMsg About.Msg
    | PublicKeysMsg PublicKeys.Msg
    | ContactMsg Contact.Msg
    | NavMsg Navbar.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoTo page ->
            ( { model | current_page = page }, Cmd.none )

        NavMsg state ->
            ( { model | nav_state = state }, Cmd.none )

        BlogMsg submsg ->
            let
                result =
                    Blog.update submsg model.blog
            in
                ( { model | blog = Tuple.first result }
                , Cmd.map BlogMsg <| Tuple.second result
                )

        AboutMsg submsg ->
            ( { model | about = About.update submsg model.about }
            , Cmd.none
            )

        PublicKeysMsg submsg ->
            ( { model | public_keys = PublicKeys.update submsg model.public_keys }
            , Cmd.none
            )

        ContactMsg submsg ->
            ( { model | contact = Contact.update submsg model.contact }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
