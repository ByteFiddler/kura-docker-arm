#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DATETIME=$(date '+%Y%m%d%H%M%S')

REPO=bytefiddler
IMAGE=$(basename $DIR)
TAG="arm"
FULL_TAG=${REPO}/${IMAGE}:${TAG}

mkdir -p ${DIR}/log
echo "Build image, write log to : ${DIR}/log/docker-build.${DATETIME}.log"
docker build --tag ${FULL_TAG} $DIR 2>&1 | tee ${DIR}/log/docker-build.${DATETIME}.log

TAG="latest"
FULL_TAG=${REPO}/${IMAGE}:${TAG}

docker manifest create ${FULL_TAG} ${FULL_TAG} | exit 0
docker manifest annotate --arch arm ${FULL_TAG} ${FULL_TAG}

echo "Push image ..."
docker push ${FULL_TAG}

echo "Done"
