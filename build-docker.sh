#!/bin/sh

VERSION=$(cat VERSION)
NAME=openvpn-server

sudo docker build -f Dockerfile -t tuonglan/${NAME}:${VERSION} .
