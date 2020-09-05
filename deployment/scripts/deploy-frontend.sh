#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"
cd ../../frontend

ember deploy production
scp production-server.js package.json rfmb@rundfunk-mitbestimmen.de:/home/rfmb/rundfunk-frontend/
# TODO: only install production dependencies
# Running into: https://github.com/ember-cli/ember-fetch/issues/115
ssh rfmb@rundfunk-mitbestimmen.de 'cd rundfunk-frontend/ && yarn install --production=false'
ssh rfmb@rundfunk-mitbestimmen.de 'supervisorctl reread && supervisorctl update && supervisorctl restart rundfunk-frontend'
