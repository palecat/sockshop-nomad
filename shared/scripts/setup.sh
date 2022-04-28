#!/bin/bash

set -e

# Disable interactive apt prompts
export DEBIAN_FRONTEND=noninteractive

NOMADCONFIGDIR=/etc/nomad.d
NOMADDIR=/opt/nomad

CONSULCONFIGDIR=/etc/consul.d
CONSULDIR=/opt/consul


# Install necessary dependencies
sudo apt-get -y -qq install curl unzip

# Install Nomad
curl "https://hc-mirror.express42.net/nomad/1.2.6/nomad_1.2.6_linux_amd64.zip" -o nomad.zip 
unzip nomad.zip -d /usr/local/bin
sudo chmod 0755 /usr/local/bin/nomad
sudo chown root:root /usr/local/bin/nomad

## Configure
sudo mkdir -p $NOMADCONFIGDIR
sudo chmod 755 $NOMADCONFIGDIR
sudo mkdir -p $NOMADDIR
sudo chmod 755 $NOMADDIR

# Install Consul
curl "https://hc-mirror.express42.net/consul/1.11.4/consul_1.11.4_linux_amd64.zip" -o consul.zip
unzip consul.zip -d /usr/local/bin

## Configure
sudo mkdir -p $CONSULCONFIGDIR
sudo chmod 755 $CONSULCONFIGDIR
sudo mkdir -p $CONSULDIR
sudo chmod 755 $CONSULDIR

# Disable systemd-resolved
systemctl disable systemd-resolved.service
systemctl stop systemd-resolved
rm -f /etc/resolv.conf
tee /etc/resolv.conf << END
nameserver 8.8.8.8
nameserver 1.1.1.1
END
