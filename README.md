Contains everything necessary to build and run my personal website [arnstrom.se](https://arnstrom.se).


## Build
Build using Docker.
```
docker build -t arnstrom .
```

## Run
```
docker run --rm -it -p 3000:80 arnstrom
```

## Test
Uses [elm-test](https://github.com/elm-community/elm-test) for all testing.
```
elm-test
```
