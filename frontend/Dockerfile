# build and test
# ==============
FROM danlynn/ember-cli:3.7.1 as build_and_test
EXPOSE 4200 49152 7357
ARG EMBER_ROOT=/frontend
WORKDIR $EMBER_ROOT

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --non-interactive
COPY . .
RUN yarn run build

# production
# ==============
FROM node:10-alpine as production
EXPOSE 4200
ARG EMBER_ROOT=/frontend
WORKDIR $EMBER_ROOT
ENV PORT=4200
ENV NODE_ENV=production

RUN apk --no-cache add git
COPY package.json yarn.lock ./
# install only production dependencies
RUN yarn install --frozen-lockfile --non-interactive
COPY --from=build_and_test /frontend/dist ./dist
COPY --from=build_and_test /frontend/production-server.js ./
CMD ["node", "production-server.js"]

