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
                    file2post file
                        |> Expect.equal expectedPost
        , test "non-working: Name contains spaces" <|
            \_ ->
                let
                    file =
                        File "2435-name containing spaces.md" "ulr"

                    expectedPost =
                        Nothing
                in
                    file2post file
                        |> Expect.equal expectedPost
        ]


extractPostName_suite : Test
extractPostName_suite =
    describe "test the extractPostName function"
        [ test "working example" <|
            \_ ->
                let
                    post =
                        Post "1939-asdfadsf.md" Nothing

                    expected =
                        "asdfadsf"
                in
                    extractPostName post
                        |> Expect.equal expected
        , test "name contains underscores" <|
            \_ ->
                let
                    post =
                        Post "98243975-kjb23_2342_34.md" Nothing

                    expected =
                        "kjb23_2342_34"
                in
                    extractPostName post
                        |> Expect.equal expected
        , test "name contains dashes" <|
            \_ ->
                let
                    post =
                        Post "9873947534-askjew-234-sdf-df-.md" Nothing

                    expected =
                        "Name not found!"
                in
                    extractPostName post
                        |> Expect.equal expected
        , fuzz string "fuzzing the name" <|
            \randString ->
                let
                    post =
                        Post randString Nothing

                    expected =
                        "Name not found!"
                in
                    extractPostName post
                        |> Expect.equal expected
        ]


isBlogPost_suite : Test
isBlogPost_suite =
    describe "test the isBlogPost function"
        [ test "working example" <|
            \_ ->
                let
                    file =
                        File "8776477-lkdjhfg_lasd_llskjlsd.md" ""
                in
                    isBlogPost file
                        |> Expect.true "Expected name to be valid"
        , test "working example #2" <|
            \_ ->
                let
                    file =
                        File "893-akjshdf.md" ""
                in
                    isBlogPost file
                        |> Expect.true "basic name should work"
        , test "post-name missing '.md' shouldnt work" <|
            \_ ->
                let
                    file =
                        File "1111-random_name" ""
                in
                    isBlogPost file
                        |> Expect.false "Name is missing .md and shouldnt work"
        , fuzz string "fuzzing shouldnt work in 99.99% of cases" <|
            \randString ->
                let
                    file =
                        File randString ""
                in
                    isBlogPost file
                        |> Expect.false "Fuzzing shouldn't trigger a true value."
        ]
