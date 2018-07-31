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
import Pages.Home as Home
import Pages.About as About
import Pages.PublicKeys as PublicKeys
import Pages.Contact as Contact


main =
    Navigation.program locFor
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- ROUTING


type Page
    = Home
    | About
    | PublicKeys
    | Contact


route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map Home (UrlParser.s "home")
        , UrlParser.map About (UrlParser.s "about")
        , UrlParser.map PublicKeys (UrlParser.s "public_keys")
        , UrlParser.map Contact (UrlParser.s "contact")
        ]


parsePage : Location -> Page
parsePage location =
    case UrlParser.parseHash route location of
        Just page ->
            page

        Nothing ->
            Home


locFor : Location -> Msg
locFor location =
    GoTo (parsePage location)



-- MODEL


type alias Model =
    { current_page : Page
    , nav_state : Navbar.State
    , home : Home.Model
    , about : About.Model
    , public_keys : PublicKeys.Model
    , contact : Contact.Model
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( nav_state, nav_cmd ) =
            Navbar.initialState NavMsg
    in
        ( { current_page = parsePage location
          , nav_state = nav_state
          , home = Home.init
          , about = About.init
          , public_keys = PublicKeys.init
          , contact = Contact.init
          }
        , nav_cmd
        )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ view_navbar model
        , view_page model
        ]


view_navbar : Model -> Html Msg
view_navbar model =
    Navbar.config NavMsg
        |> Navbar.container
        |> Navbar.lightCustom Color.white
        |> Navbar.brand [ href "#/home" ] [ h2 [] [ text "Lucas Arnström" ] ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#/about" ] [ text "About" ]
            , Navbar.itemLink [ href "#/public_keys" ] [ text "Public Keys" ]
            , Navbar.itemLink [ href "#/contact" ] [ text "Contact" ]
            ]
        |> Navbar.view model.nav_state


view_page : Model -> Html Msg
view_page model =
    Grid.container [] <|
        case model.current_page of
            Home ->
                Home.view model.home

            About ->
                About.view model.about

            PublicKeys ->
                PublicKeys.view model.public_keys

            Contact ->
                Contact.view model.contact



-- UPDATE


type Msg
    = GoTo Page
    | NavMsg Navbar.State


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoTo page ->
            ( { model | current_page = page }, Cmd.none )

        NavMsg state ->
            ( { model | nav_state = state }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
