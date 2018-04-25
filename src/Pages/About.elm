module Pages.About exposing (..)

import Html exposing (Html, text, h3)
import Markdown
import Bootstrap.Grid as Grid


type alias Model =
    {}


init : Model
init =
    {}


content : Html msg
content =
    Markdown.toHtml [] """
### About
I'm a DevOps engineer working within VoIP communication and web development, currently employed by [Bahnhof](https://bahnhof.se) which is a Swedish ISP and ITSP focused on privacy and security.

My line of work includes full stack web development, [Docker](https://docker.com) & [Kubernetes](https://kubernetes.io) architecture and administration. I also work with designing, building, and maintaining VoIP communication systems for the ITSP using [OpenSIPS](https://opensips.org), [Asterisk](https://asterisk.org), and various other technologies.

Working on awesome projects is both my hobby and my line of work.

### Github
You can see all my public repositories [here](https://github.com/chilinot).
"""


view : Model -> List (Html msg)
view model =
    [ Grid.row []
        [ Grid.col [] [ content ] ]
    ]
