#!/bin/bash

# Install tools
apt-get update
apt-get install -y curl unzip collectd

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
chmod 755 /var/local/nomad
