##### Compile project
FROM codesimple/elm:0.18

WORKDIR /home/node/app

# Insert package specification
COPY --chown=node:node elm-package.json .

# Install dependencies
RUN elm-package install -y && \
    npm install -g uglify-js@3.3.21 \
                   elm-test@0.18.12

# Insert source code
COPY --chown=node:node . .

# Compile project
RUN elm-make src/Main.elm --output elm.js && \
    uglifyjs --compress --mangle -- elm.js > elm.min.js

##### Construct production image
FROM nginx:1.13-alpine

# Configure nginx
COPY nginx /etc/nginx/conf.d

# Insert non-elm code
COPY static /var/www

# Insert compiled elm code
COPY --from=0 /home/node/app/elm.min.js /var/www/elm.min.js
