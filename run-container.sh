#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

REPO=bytefiddler
IMAGE=$(basename $DIR)
TAG="latest"
FULL_TAG=${REPO}/${IMAGE}:${TAG}

GLUSTER_MOUNT=/mnt/kura

if [ -d $GLUSTER_MOUNT ]; then
	docker run -d -p 80:80 -v $GLUSTER_MOUNT:$GLUSTER_MOUNT $FULL_TAG /start.sh 128m
else
	docker run -d -p 80:80 $FULL_TAG /start.sh
fi
