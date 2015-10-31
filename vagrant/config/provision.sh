#!/bin/bash
sudo cp /vagrant/config/hosts /etc/hosts

sudo cp /vagrant/nomad/nomad-client.service \
/vagrant/nomad/nomad-server.service \
/vagrant/nomad/server.hcl \
/vagrant/nomad/general.hcl \
/etc/nomad/

NAME=$(printf "$1-%02d" $2)
IP="172.17.8.$((100+$2))"
printf 'name="%s"\nbind_addr="%s"' $NAME $IP > /etc/nomad/node.hcl

sudo cp /vagrant/nomad/client.hcl /home/vagrant/

sudo systemctl daemon-reload
