FROM rundfunk-mitbestimmen-backend

WORKDIR /features

RUN gem install bundler
ADD Gemfile /features/Gemfile
ADD Gemfile.lock /features/Gemfile.lock
RUN bundle install

ADD . /features
