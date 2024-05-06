#!/bin/bash

# Check if the tag parameter is provided
if [ -z "$1" ]
then
    echo "No tag provided. Usage: ./script.sh <tag>"
    exit 1
fi

TAG=$1
DOCKERFILE="$TAG.dockerfile"

echo "docker build and push"
docker build --progress plain -f "$DOCKERFILE" -t europe-docker.pkg.dev/shared/docker-repo-shared/cloud-sdk-company-01-cicd-be:"$TAG" . --no-cache
docker push europe-docker.pkg.dev/shared/docker-repo-shared/cloud-sdk-company-01-cicd-be:"$TAG"
