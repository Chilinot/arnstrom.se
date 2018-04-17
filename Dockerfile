##### Compile project
FROM codesimple/elm:0.18

WORKDIR /home/node/app

# Insert package specification
COPY --chown=node:node elm-package.json .

# Install dependencies
RUN elm-package install -y && \
    npm install -g uglify-js@3.3.21

# Insert source code
COPY --chown=node:node . .

# Compile project
RUN elm-make src/*.elm --output elm.js && \
    uglifyjs --compress --mangle -- elm.js > elm.min.js

##### Construct production image
FROM nginx:1.13-alpine

# Insert non-elm code
COPY static /usr/share/nginx/html

# Insert compiled elm code
COPY --from=0 /home/node/app/elm.min.js /usr/share/nginx/html/elm.min.js
