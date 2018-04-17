FROM rundfunk-mitbestimmen-backend

RUN yum install -y libX11
RUN yum install -y epel-release
RUN yum install -y chromium

WORKDIR /features
RUN mv /backend /features/backend

ADD Gemfile /features/Gemfile
ADD Gemfile.lock /features/Gemfile.lock
RUN bundle install

ADD . /features
