module BlogDecoder exposing (..)

import Regex exposing (Regex, regex, contains)
import Json.Decode exposing (string, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


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


{-| Represents a blogpost, with optionally downloaded contents.
The contents is the raw markdown from the file, as a single string.
-}
type alias Post =
    { name : String
    , download_url : String
    , contents : Maybe String
    }


{-| Converts a File to a Post, if it is actully a blog post.
-}
file2Post : File -> Maybe Post
file2Post file =
    if isBlogPost file then
        Just <| Post file.name file.download_url Nothing
    else
        Nothing


{-| Decodes the returned content of a blog post.
Right now this is only handled as a string. Which is very
likely to change in the future.
-}
postContentDecoder : Decoder String
postContentDecoder =
    Json.Decode.string


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
contentListDecoder : Decoder (List File)
contentListDecoder =
    --Json.Decode.decodeString (list fileDecoder) json
    --    |> Result.withDefault [ File "No blogpost found!" "" ]
    list fileDecoder


{-| Retrieves the name of the post from the filename using regex.
-}
extractPostName : Post -> String
extractPostName post =
    Regex.find Regex.All blogpost_regex post.name
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
