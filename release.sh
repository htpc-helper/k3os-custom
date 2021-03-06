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
mkdir -p iso iso-new/boot/grub
osirrox -indev k3os-amd64.iso -extract / iso/
cp -rf iso/k3os iso-new/
cp iso/boot/grub/grub.cfg iso-new/boot/grub/
sudo rm -rf iso-new/k3os/system/config.yaml
sudo cp config.yaml iso-new/k3os/system/
grub-mkrescue -o "k3os-${RELEASE_VERSION}-amd64.iso" iso-new/ -- -volid K3OS

# Transfer iso to s3
~/mc cp k3os-${RELEASE_VERSION}-amd64.iso s3/goong-static/


