#!/usr/bin/env bash
set -e
cd ../frontend
ember deploy production
ssh rfmb@rundfunk-mitbestimmen.de "svc -du ~/service/rundfunk-frontend"
