#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
cd ../../backend

rvm $TRAVIS_RUBY_VERSION do gem install bundler capistrano capistrano-rails capistrano-db-tasks
rvm $TRAVIS_RUBY_VERSION do cap production deploy

