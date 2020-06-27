
#! /usr/bin/env bash

REPO="iraadit"
IMAGE="fn"
TAG="latest"

docker build --tag ${REPO}/${IMAGE}:${TAG} .
