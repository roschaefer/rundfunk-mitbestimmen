FROM node:6.10-alpine

RUN apk add --no-cache git

WORKDIR /frontend

ADD package.json /frontend/package.json
RUN npm install

ADD . /frontend

EXPOSE 49152
EXPOSE 4200
