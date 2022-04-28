#!/bin/bash

set -e

CONFIGDIR=/tmp/shared/config
CONSULCONFIGDIR=/etc/consul.d
NOMADCONFIGDIR=/etc/nomad.d

IP_ADDRESS=$1
RETRY_JOIN=$2

sudo apt-get -qq update

# Install necessary dependencies
sudo apt-get -y -qq install ca-certificates curl gnupg lsb-release

# Install Docker
curl "https://mirror.yandex.ru/mirrors/docker/dists/focal/pool/stable/amd64/docker-ce_20.10.9~3-0~ubuntu-focal_amd64.deb" -o docker-ce.deb
curl "https://mirror.yandex.ru/mirrors/docker/dists/focal/pool/stable/amd64/containerd.io_1.5.11-1_amd64.deb" -o containerd.io.deb
curl "https://mirror.yandex.ru/mirrors/docker/dists/focal/pool/stable/amd64/docker-ce-cli_20.10.9~3-0~ubuntu-focal_amd64.deb" -o docker-ce-cli.deb
curl "https://mirror.yandex.ru/mirrors/docker/dists/focal/pool/stable/amd64/docker-ce-rootless-extras_20.10.14~3-0~ubuntu-focal_amd64.deb" -o docker-ce-rootless-extras.deb
sudo apt-get install -y -qq ./*.deb
sudo usermod -aG docker $USER

sed -i "s/IP_ADDRESS/$IP_ADDRESS/g" $CONFIGDIR/consul_client.hcl
sed -i "s/RETRY_JOIN/$RETRY_JOIN/g" $CONFIGDIR/consul_client.hcl
sudo cp $CONFIGDIR/consul_client.hcl $CONSULCONFIGDIR/consul.hcl
sudo cp $CONFIGDIR/consul.service /etc/systemd/system/consul.service

sudo systemctl enable consul.service
sudo systemctl start consul.service
sleep 10

sudo cp $CONFIGDIR/nomad_client.hcl $NOMADCONFIGDIR/nomad.hcl
sudo cp $CONFIGDIR/nomad.service /etc/systemd/system/nomad.service

sudo systemctl enable nomad.service
sudo systemctl start nomad.service
sleep 10

export NOMAD_ADDR=http://$IP_ADDRESS:4646

# Add hostname to /etc/hosts
echo "127.0.0.1 $(hostname)" | sudo tee --append /etc/hosts

sudo docker network create sockshop-network
