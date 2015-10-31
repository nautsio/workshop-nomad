#!/bin/bash
MACHINE_PREFIX=$1
MACHINE_ID=$2
NUM_INSTANCES=$3

sudo cp /vagrant/nomad/nomad-client.service \
  /vagrant/nomad/nomad-server.service \
  /vagrant/nomad/server.hcl \
  /vagrant/nomad/client.hcl \
  /vagrant/nomad/general.hcl \
  /etc/nomad/

function writeNomadNodeConfig() {
  local NAME=$(printf "$MACHINE_PREFIX-%02d" $MACHINE_ID)
  local BINDADDR="172.17.8.$((100+$MACHINE_ID))"
  printf 'name="%s"\nbind_addr="%s"' $NAME $BINDADDR > /etc/nomad/node.hcl
}

function generateNodeHostsLine() {
  local HOST=$(printf "$MACHINE_PREFIX-%02d" $1)
  local IP="172.17.8.$((100+$1))"

  echo "$IP   $HOST"
}

function writeHostsFile() {
  local LOCALHOST="127.0.0.1    localhost"
  echo $LOCALHOST > /etc/hosts
  for ((i=1; i<=$NUM_INSTANCES; i++))
  do
    echo $(generateNodeHostsLine $i) >> /etc/hosts
  done
}

writeHostsFile
writeNomadNodeConfig
sudo systemctl daemon-reload
