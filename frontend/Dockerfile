FROM danlynn/ember-cli:3.1.4

WORKDIR /frontend

ADD package.json /frontend/package.json
ADD yarn.lock /frontend/yarn.lock
RUN yarn install

ADD . /frontend

EXPOSE 4200 49152 7357
