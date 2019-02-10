FROM ruby:2.6-alpine
EXPOSE 3000

ARG RAILS_ROOT=/backend
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql postgresql-dev yaml-dev zlib-dev"
ARG RUBY_PACKAGES="tzdata"
WORKDIR $RAILS_ROOT

COPY Gemfile* ./
RUN apk update && apk upgrade && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES
RUN bundle config --global frozen 1 && bundle install --path=vendor/bundle
COPY . .
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

