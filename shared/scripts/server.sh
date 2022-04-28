#!/bin/bash

set -e

CONFIGDIR=/tmp/shared/config
CONSULCONFIGDIR=/etc/consul.d
NOMADCONFIGDIR=/etc/nomad.d

IP_ADDRESS=$1
SERVER_COUNT=$2
RETRY_JOIN=$3

sed -i "s/IP_ADDRESS/$IP_ADDRESS/g" $CONFIGDIR/consul_server.hcl
sed -i "s/SERVER_COUNT/$SERVER_COUNT/g" $CONFIGDIR/consul_server.hcl
sed -i "s/RETRY_JOIN/$RETRY_JOIN/g" $CONFIGDIR/consul_server.hcl
sudo cp $CONFIGDIR/consul_server.hcl $CONSULCONFIGDIR/consul.hcl
sudo cp $CONFIGDIR/consul.service /etc/systemd/system/consul.service

sudo systemctl enable consul.service
sudo systemctl start consul.service
sleep 10

export CONSUL_HTTP_ADDR=$IP_ADDRESS:8500

sed -i "s/SERVER_COUNT/$SERVER_COUNT/g" $CONFIGDIR/nomad_server.hcl
sudo cp $CONFIGDIR/nomad_server.hcl $NOMADCONFIGDIR/nomad.hcl
sudo cp $CONFIGDIR/nomad.service /etc/systemd/system/nomad.service

sudo systemctl enable nomad.service
sudo systemctl start nomad.service
sleep 10

# Add hostname to /etc/hosts

echo "127.0.0.1 $(hostname)" | sudo tee --append /etc/hosts
