module Pages.PublicKeys exposing (..)

import Html exposing (Html, text, h4, pre)
import Markdown
import Bootstrap.Grid as Grid
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block


type alias Model =
    {}


init : Model
init =
    {}


ssh_key : String
ssh_key =
    """
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuEDd7MuxMotLwLNqtFFqck4i6
AGoUxx/H3NXEw4KY8aBPYu7OeMAMkI1VM2eId6mDV/wlGAJ/5GS7vOWWBMUV2vbe
6/Y3BOrdurY7FDu2JEpWMtmS7qgF0/Qg/fAkV9sSIgTCylprJ8h3pHMn7KASQc94
NTYSEPPluObVDWT4NSpmVR50ItXb0RttuJkfTfxwrsFCHRHpEKELSs9UUx1RdJhy
mffh3Z/1GVOczWjFSJCtnxYOTZOT53eiIFagfxAGWAy6zLuvrHYlhelKRipknsli
GU+1MRRJc7K2EMl8sGKxuFp1ElRGOzX6b/09unvr2d9m+pT/bucIrJREm0nl
lucas@Lucas-Laptop
"""


pgp_key : String
pgp_key =
    """
-----BEGIN PGP PUBLIC KEY BLOCK-----
mQENBFcJfFIBCACz//QxwD+PbheGJOaXAIerJF/yDZyCA9JNnSK5ucvKrdMx3p7k
BbvuU2qarcth/i6JyXJowYhWynKCW5VRt+C9yoiBYwnyKzN1FUnFzceclBdqDBQY
kNgDM11+0wjY2M+RKvEeN597VkzYiSTUzmr6HCidM0/26Ehd3LUl3vprJQaepVQQ
DiSz3m4jfSlvM2av+9F3stzWjD53E9d1f6ZFFi8CMSH8ALuLylxnZI5rIAkVQBBQ
d4wwuVAbrnKA5UBYyhxvXVO071esns+ZkaimlsCh8z9b3WuUVzw45N8Ev2lOIdzi
HRlnjO9uh7P/Lt6Oif5kJwOmOsU/rTDGm3tZABEBAAG0I0x1Y2FzIEFybnN0csO2
bSA8bHVjYXNAYXJuc3Ryb20uc2U+iQE3BBMBCAAhBQJXCXxSAhsDBQsJCAcCBhUI
CQoLAgQWAgMBAh4BAheAAAoJEOrncjdFEaWHxOgH/11sL6qiQwX8KIjndLH0woyO
L/ABFXxlwAVN1gkdLD0ypqYrf6ggy04W3fYM1lGzDlTsHpGKGhEqBfZLOfGWRDJs
e2LFj2UrRfufewOcEumqkYxxzEAV65SqA2C+k3cI0U/UcjwQdFVam5hJFALMac/6
REadVpub1nKXf6QtWhG+bqKIEl9tQR1VrgZtBr+HA92Id/H6MNGdNbMhEdODh/Op
G9IXt/5pKEacF+qGDcQqh22xzf9WmBG7YzJXYGGdiZBTBJHFydY8GTYlhJwT3KRa
571wL73GNEEa5W2zfzCklXtTHqzmtiwPRaN+ttjqyOcuss0pS91bGkuWyATZA4i5
AQ0EVwl8UgEIAMRIZknnzp+LMZlV2bmeqbmBEPLtPeVzvXE3GthSCFog6qUw5oZY
hUvATHmjNUJYhabsKVi9ZOxFymKPj43sBVN8EjjtFK7r/IntFegySN3a7tc8NIQT
wAKuDQv1Au/USOiMBxF9OEIUpXBVw6Kdw8dTyWX8IPUh9igcsfMln86YN7Frfgsn
3wx7OMrdxxXo2nidATUv4cWaE0QowhPI61hTk7f+aVY1LR+B9OJc7XeiiW/NtckU
A23BEZfNEJF/vvgJ7txDmACrXuPzXSt0f7G5FSC9e5XVNOp+Fq13Qn8QKcMKsPlH
cnF9KYy0mhafXHVbveRLtfAztX5dvo9izOEAEQEAAYkBHwQYAQgACQUCVwl8UgIb
DAAKCRDq53I3RRGlh6ezB/9NJwfJrIAoC2COs8XReyDUL+7+Qg5nookw68maetwn
Fi7+qhQUPk0iqb8uiXCzKdw7dDBFHS5lfC42a6n32JA92GnzFvf8wtsdxLd4I1Jr
tsz4rtR3sbu4QSwb7uZyrVTkUjY1hd7zoCRcgO+W8Vrqr6eA0tw7tw0fHd6sI8vO
73SbgPEpaCme4P7qFvC9ysK8UCCiieScTgxTxS+FZS/9NEPl5r9Xv5y8Y6l7SaPK
Laxhb4lD3fNzDBP4KTv3/zWSloF3YDiy0MaF5c9xvYcQagvRxRzef0+l545eHSPy
4ail63dS2GegQaRPXYoKtBSGsGVrP+IFB7StxMUG2DgK
=gJXj
-----END PGP PUBLIC KEY BLOCK-----
"""


view : Model -> List (Html msg)
view model =
    [ Grid.row []
        [ Grid.col []
            [ h4 [] [ text "SSH" ]
            , Card.config []
                |> Card.block []
                    [ Block.text [] [ pre [] [ text ssh_key ] ] ]
                |> Card.view
            ]
        ]
    , Grid.row []
        [ Grid.col []
            [ h4 [] [ text "PGP" ]
            , Card.config []
                |> Card.block []
                    [ Block.text [] [ pre [] [ text pgp_key ] ] ]
                |> Card.view
            ]
        ]
    ]
