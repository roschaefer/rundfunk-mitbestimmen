FROM node:6.10-alpine

RUN apk add --no-cache git

WORKDIR /frontend

ADD . /frontend

RUN npm install -g bower@1.8.0
RUN npm install
RUN bower install --allow-root

EXPOSE 49152
EXPOSE 4200
