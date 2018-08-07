module BlogDecoder exposing (..)

import Regex exposing (Regex, regex, contains)
import Json.Decode exposing (string, list, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


{-| For retrieving the contents of the master branch of the github repo.
-}
root_contents_url : String
root_contents_url =
    "https://api.github.com/repos/chilinot/blog/contents"


root_download_url : String
root_download_url =
    "https://raw.githubusercontent.com/Chilinot/blog/master/"


{-| Detetermines whether the string matches the expected
structure for a blogpost filename.
-}
blogpost_regex : Regex
blogpost_regex =
    regex "^(\\d+)-(\\w+)\\.md$"


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
    , contents : Maybe String
    }


{-| For sorting lists of Post-records.
-}
postComparable : Post -> Int
postComparable post =
    extractPostId post


{-| Converts a File to a Post, if it is actully a blog post.
-}
file2post : File -> Maybe Post
file2post file =
    if isBlogPost file then
        Just <| Post file.name Nothing
    else
        Nothing


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
        -- .submatches returns a list, we have two subgroups, one for the id, one for the name.
        -- Grab the second, by removing the first, then grabbing the head:
        |> List.drop 1
        |> List.head
        -- List.head returns a Maybe-value so now we have a "Maybe (Maybe String)",
        -- unwrap the outer Maybe value.
        |> Maybe.withDefault Nothing
        -- Unwrap the inner "Maybe String".
        |> Maybe.withDefault "Name not found!"


{-| Retrieves the ID of the post from the filename.
Returns -1 if the ID could not be retrieved/found.
Returns -2 if the ID was not a valid number.
-}
extractPostId : Post -> Int
extractPostId post =
    Regex.find Regex.All blogpost_regex post.name
        |> List.head
        |> Maybe.withDefault (Regex.Match "" [] 0 0)
        |> .submatches
        |> List.head
        |> Maybe.withDefault Nothing
        |> Maybe.withDefault "-1"
        |> String.toInt
        |> Result.withDefault -2


{-| Uses regular expressions to determine whether a File
represents a blogpost or not.
-}
isBlogPost : File -> Bool
isBlogPost file =
    contains blogpost_regex file.name
