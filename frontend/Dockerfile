FROM node:6.10-alpine

RUN apk add --no-cache git

WORKDIR /frontend

ADD package.json /frontend/package.json
RUN npm install

RUN npm install -g bower@1.8.0
ADD bower.json /frontend/bower.json
RUN bower install --allow-root

ADD . /frontend

EXPOSE 49152
EXPOSE 4200
