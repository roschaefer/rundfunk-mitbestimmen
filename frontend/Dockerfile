FROM node:10-alpine as base
EXPOSE 4200 49152 7357
ARG EMBER_ROOT=/frontend
WORKDIR $EMBER_ROOT

COPY package.json ./package.json
COPY yarn.lock ./yarn.lock

FROM base as build_and_test
RUN apk --no-cache add git
RUN yarn install --frozen-lockfile --non-interactive
COPY . .
RUN yarn run build

FROM base as production
ENV NODE_ENV=production
RUN yarn install --frozen-lockfile --non-interactive
COPY --from=build_and_test /frontend/dist ./dist
COPY --from=build_and_test /frontend/production-server.js ./
CMD ["node", "production-server.js"]

