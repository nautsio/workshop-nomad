#!/bin/bash
MACHINE_PREFIX=$1
MACHINE_ID=$2
NUM_INSTANCES=$3

sudo install -o root -g root -m 644 /vagrant/files/etc/systemd/system/nomad.service /etc/systemd/system/nomad.service
sudo install -o root -g root -m 755 -d /etc/nomad.d
sudo install -o root -g root -m 644 /vagrant/files/etc/nomad.d/* /etc/nomad.d

function writeNomadNodeConfig() {
  local NAME=$(printf "$MACHINE_PREFIX-%02d" $MACHINE_ID)
  local BINDADDR="172.17.8.$((100+$MACHINE_ID))"
  printf 'name="%s"\nbind_addr="%s"' $NAME $BINDADDR > /etc/nomad.d/node.hcl
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
