#!/usr/bin/env bash
set -e
cd ../backend
rvm $TRAVIS_RUBY_VERSION do cap production deploy
