module BlogDecoderTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import BlogDecoder exposing (..)


file2post_suite : Test
file2post_suite =
    describe "tests the file2post function"
        [ test "working example" <|
            \_ ->
                let
                    file =
                        BlogDecoder.File "234-some_random_name.md" "download_url"

                    expectedPost =
                        Just <| BlogDecoder.Post "234-some_random_name.md" Nothing
                in
                    file2post file |> Expect.equal expectedPost
        , test "non-working: Name contains spaces" <|
            \_ ->
                let
                    file =
                        File "2435-name containing spaces.md" "ulr"

                    expectedPost =
                        Nothing
                in
                    file2post file |> Expect.equal expectedPost
        ]
