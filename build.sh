#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DATETIME=$(date '+%Y%m%d%H%M%S')

REPO=bytefiddler
IMAGE=$(basename $DIR)
TAG="$(uname -m)"
FULL_TAG=${REPO}/${IMAGE}:${TAG}

mkdir -p ${DIR}/log
echo "Build image, write log to : ${DIR}/log/docker-build.${DATETIME}.log"
docker build --tag $FULL_TAG $DIR 2>&1 | tee ${DIR}/log/docker-build.${DATETIME}.log

echo "Push image ..."
docker push $FULL_TAG

echo "Purge manifest (push --purge) ..."
docker manifest push --purge $FULL_TAG | exit 0
docker manifest push --purge ${REPO}/${IMAGE}:latest | exit 0

echo "Create manifest ..."
docker manifest create ${REPO}/${IMAGE}:latest $FULL_TAG | exit 0

echo "Annotate manifest ..."
docker manifest annotate --arch arm --variant v5 ${REPO}/${IMAGE}:latest $FULL_TAG

echo "Push manifest ..."
docker manifest push ${REPO}/${IMAGE}:latest

echo "Done"
