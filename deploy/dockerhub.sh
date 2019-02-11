#!/usr/bin/env bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push rundfunkmitbestimmen/frontend:latest
docker push rundfunkmitbestimmen/backend:latest
