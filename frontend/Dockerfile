FROM danlynn/ember-cli:3.7.1 as build_and_test
EXPOSE 4200 49152 7357
ARG EMBER_ROOT=/frontend
WORKDIR $EMBER_ROOT
COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

RUN yarn install --frozen-lockfile --non-interactive
COPY . .
RUN yarn run build



FROM node:10-alpine as production
EXPOSE 4200 49152 7357
ARG EMBER_ROOT=/frontend
WORKDIR $EMBER_ROOT
COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

ENV NODE_ENV=production
RUN apk --no-cache add git
RUN yarn install --frozen-lockfile --non-interactive
COPY --from=build_and_test /frontend/dist ./dist
COPY --from=build_and_test /frontend/production-server.js ./
CMD ["node", "production-server.js"]

