#!/bin/bash
# Quit on errors.
set -e

# Install Docker and add vagrant to docker group.
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker vagrant

# Docker overlay networking.
sudo install -o root -g root -m 755 -d /etc/systemd/system/docker.service.d
sudo install -o root -g root -m 644 /tmp/etc/systemd/system/docker.service.d/cluster.conf /etc/systemd/system/docker.service.d/cluster.conf

# Pull all images we want to pre-load for the workshop.
