FROM node:8.11.1-alpine

RUN apk add --no-cache git

WORKDIR /frontend

ADD package.json /frontend/package.json
ADD yarn.lock /frontend/yarn.lock
RUN yarn install
RUN yarn global add ember-cli

ADD . /frontend

EXPOSE 4200 49152 7357
