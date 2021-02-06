#!/bin/sh

VERSION=$(cat VERSION)
NAME=openvpn-server

sudo docker push tuonglan/${NAME}:${VERSION}
