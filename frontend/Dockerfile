FROM node:6.10

WORKDIR /frontend

ADD . /frontend

RUN npm install -g ember-cli bower
RUN npm install
RUN bower install --allow-root

EXPOSE 49152
EXPOSE 4200
