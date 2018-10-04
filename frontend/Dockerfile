FROM danlynn/ember-cli:3.4.3-node_10.11
EXPOSE 4200 49152 7357
WORKDIR /frontend

ADD package.json /frontend/package.json
ADD yarn.lock /frontend/yarn.lock
RUN yarn install

ADD . /frontend

RUN ember build
