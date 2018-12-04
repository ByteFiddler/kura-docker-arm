#!/bin/bash

set -e

if [ -z "$1" ]; then
	echo "No ARCH specified. Example: ./build.sh arm32v7" 1>&2
	exit 1
fi

ARCH="$1"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
REPO=wuodan
IMAGE=$(basename $DIR)
TAG="$(docker info -f '{{.Architecture}}')"
FULL_TAG=${REPO}/${IMAGE}:${TAG}
DATETIME=$(date '+%Y%m%d%H%M%S')

mkdir -p ${DIR}/log
echo "Build image, write log to : ${DIR}/log/docker-build.${DATETIME}.log"
docker build --build-arg ARCH="${ARCH}" --tag ${FULL_TAG} $DIR 2>&1 | tee ${DIR}/log/docker-build.${DATETIME}.log

echo "Push image ..."
docker push ${FULL_TAG}

echo "Done"
