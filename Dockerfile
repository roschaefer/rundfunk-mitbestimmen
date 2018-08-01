FROM rundfunk-mitbestimmen-backend

RUN yum install -y libX11
RUN yum install -y epel-release
RUN yum install -y chromium

WORKDIR /fullstack

RUN mv /backend  /fullstack/backend

ADD Gemfile      /fullstack/Gemfile
ADD Gemfile.lock /fullstack/Gemfile.lock
ADD features     /fullstack/features

RUN bundle install

