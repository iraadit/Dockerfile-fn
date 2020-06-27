#! /usr/bin/env bash

REPO="iraadit"
IMAGE="fn"
TAG="latest"

if [ ! "$(docker ps -q -f name=${TAG})" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=${TAG})" ]; then
        # cleanup
        docker rm ${TAG}
    fi
    docker run -it \
           --runtime=nvidia \
           --privileged \
           --name ${TAG} \
           ${REPO}/${IMAGE}:${TAG} \
           /bin/bash
fi
