#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

REPO=bytefiddler
IMAGE=$(basename $DIR)
TAG="latest"
FULL_TAG=${REPO}/${IMAGE}:${TAG}

docker run -d -p 80:80 $FULL_TAG
