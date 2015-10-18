#!/bin/bash

# Install tools
apt-get update
apt-get install -y curl git unzip

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Install Nomad
wget -O nomad.zip https://dl.bintray.com/mitchellh/nomad/nomad_0.1.2_linux_amd64.zip
unzip nomad.zip
rm nomad.zip
mv nomad /usr/bin/nomad
chmod +x /usr/bin/nomad
mkdir /etc/nomad
chmod a+w /etc/nomad
