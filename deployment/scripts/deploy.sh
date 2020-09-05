#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"

./deploy-backend.sh
./deploy-frontend.sh
