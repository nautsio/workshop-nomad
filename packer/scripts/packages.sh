#!/bin/bash

# Install tools
apt-get update
apt-get install -y curl unzip build-essential

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Install Nomad
cd /tmp/
wget -O nomad.zip https://dl.bintray.com/mitchellh/nomad/nomad_0.1.2_linux_amd64.zip
unzip nomad.zip

mv nomad /usr/bin/nomad
chmod +x /usr/bin/nomad

mkdir /etc/nomad
chmod 755 /etc/nomad

mkdir /var/local/nomad
chmod 777 /var/local/nomad

# Install Collectd
cd /tmp/
wget https://github.com/collectd/collectd/archive/collectd-5.5.0.zip
unzip collectd-5.5.0.zip
cd collectd-5.5.0

./configure
make all install
