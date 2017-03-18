FROM ruby:2.4

WORKDIR /backend

ADD Gemfile /backend/Gemfile
ADD Gemfile.lock /backend/Gemfile.lock

RUN bundle install

EXPOSE 3000
