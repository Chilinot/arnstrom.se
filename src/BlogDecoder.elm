module BlogDecoder exposing (..)

import Html exposing (Html, text)
import Regex exposing (Regex, regex, contains)
import Json.Decode exposing (string, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


test_data : String
test_data =
    """
[
  {
    "name": "1-first.md",
    "path": "1-first.md",
    "sha": "1e1eeabc903776b3894eb295db7b06f04b2aded0",
    "size": 21,
    "url": "https://api.github.com/repos/Chilinot/blog/contents/1-first.md?ref=master",
    "html_url": "https://github.com/Chilinot/blog/blob/master/1-first.md",
    "git_url": "https://api.github.com/repos/Chilinot/blog/git/blobs/1e1eeabc903776b3894eb295db7b06f04b2aded0",
    "download_url": "https://raw.githubusercontent.com/Chilinot/blog/master/1-first.md",
    "type": "file",
    "_links": {
      "self": "https://api.github.com/repos/Chilinot/blog/contents/1-first.md?ref=master",
      "git": "https://api.github.com/repos/Chilinot/blog/git/blobs/1e1eeabc903776b3894eb295db7b06f04b2aded0",
      "html": "https://github.com/Chilinot/blog/blob/master/1-first.md"
    }
  },
  {
    "name":"asdf",
    "download_url":"asdf"
  }
]
"""


{-| For retrieving the contents of the master branch of the github repo.
-}
root_url : String
root_url =
    "https://api.github.com/repos/chilinot/blog/contents"


{-| Detetermines whether the string matches the expected
structure for a blogpost filename.
-}
blogpost_regex : Regex
blogpost_regex =
    regex "^\\d+-(\\w+)\\.md$"


{-| Represents a file in the content list returned from github.
-}
type alias File =
    { name : String
    , download_url : String
    }


{-| Decodes JSON into a File.
-}
fileDecoder : Decoder File
fileDecoder =
    decode File
        |> required "name" string
        |> required "download_url" string


{-| Decodes a JSON string into a list of Files.
For decoding the content list returned by github.
-}
contentListDecoder : String -> Result String (List File)
contentListDecoder json =
    Json.Decode.decodeString (list fileDecoder) json


{-| Retrieves the name of the post from the filename using regex.
-}
extractPostName : File -> String
extractPostName file =
    Regex.find Regex.All blogpost_regex file.name
        -- Get the first matched data from the list of matches.
        |> List.head
        -- If the list was empty, create a hacky empty "Match" object that reflects the error.
        |> Maybe.withDefault (Regex.Match "" [] 0 0)
        -- Retrieve the matched subgroups.
        |> .submatches
        -- .submatches returns a list, but we only have one subgroup, so retrieve it.
        |> List.head
        -- List.head returns a Maybe-value so now we have a "Maybe (Maybe String)",
        -- unwrap the outer Maybe value.
        |> Maybe.withDefault Nothing
        -- Unwrap the inner "Maybe String".
        |> Maybe.withDefault "Name not found!"


{-| Uses regular expressions to determine whether a File
represents a blogpost or not.
-}
isBlogPost : File -> Bool
isBlogPost file =
    contains blogpost_regex file.name


{-| Returns a list of all matched blogposts in the given list.
-}
onlyBlogPosts : List File -> List File
onlyBlogPosts list =
    List.filter isBlogPost list


{-| Creates an HTML compatible text message from the filename.
-}
renderFilename : File -> Html msg
renderFilename file =
    text <| extractPostName file


{-| Generates a list of HTML compatible text-messages from a list of files.
-}
filenames2items : List File -> List (Html msg)
filenames2items filelist =
    List.map renderFilename <| onlyBlogPosts filelist
