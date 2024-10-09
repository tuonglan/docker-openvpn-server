#!/bin/sh

VERSION=$(cat VERSION)
NAME=openvpn-server

sudo docker buildx build \
    --builder container --platform linux/arm64/v8,linux/amd64 --push \
    -f Dockerfile -t tuonglan/${NAME}:${VERSION} .
