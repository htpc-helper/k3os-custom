#!/usr/bin/env bash

set -e

# Download latest k3os iso
RELEASE_JSON=`curl -s https://api.github.com/repos/rancher/k3os/releases/latest`
RELEASE_VERSION=`echo -n $RELEASE_JSON | jq '.tag_name'`
RELEASE_VERSION=`echo -n ${RELEASE_VERSION:2:-1}`
RELEASE_URL=`echo -n "https://github.com/rancher/k3os/releases/download/v${RELEASE_VERSION}/k3os-amd64.iso"`
echo "Downloading k3os version: v${RELEASE_VERSION}"
curl -Lo k3os-amd64.iso $RELEASE_URL

# Edit the iso
mkdir iso
osirrox -indev k3os-amd64.iso -extract / iso/
rm iso/k3os/system/config.yaml
cp config.yaml iso/k3os/system/
grub-mkrescue -o "k3os-${RELEASE_VERSION}-amd64.iso" iso/ 

# Transfer iso to s3
# mc config host add s3 $ENDPOINT $ACCESS_KEY $SECRET_KEY

./mc ls s3
# mc cp k3os-${RELEASE_VERSION}.iso s3:/


