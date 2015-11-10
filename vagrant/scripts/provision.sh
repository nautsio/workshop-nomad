#!/bin/bash
MACHINE_PREFIX=$1
MACHINE_ID=$2
NUM_INSTANCES=$3

function writeNomadNodeConfig() {
  local NAME=$(printf "$MACHINE_PREFIX-%02d" $MACHINE_ID)
  local BINDADDR="172.17.8.$((100+$MACHINE_ID))"
  printf 'name="%s"\nbind_addr="%s"' $NAME $BINDADDR > /etc/nomad.d/node.hcl
}

function generateNodeHostsLine() {
  local HOST=$(printf "$MACHINE_PREFIX-%02d" $MACHINE_ID)
  local IP="172.17.8.$((100+$MACHINE_ID))"
  echo "$IP   $HOST"
}

function writeConsulNodeConfig() {
  local BINDADDR="172.17.8.$((100+$MACHINE_ID))"
  if [ $MACHINE_ID == 1 ]; then
    printf '{"bootstrap": true, "bind_addr": "%s", "client_addr": "%s"}' $BINDADDR $BINDADDR | jq . > /etc/consul.d/node.json
  else
    printf '{"start_join": ["172.17.8.101"], "bind_addr": "%s", "client_addr": "%s"}' $BINDADDR $BINDADDR | jq . > /etc/consul.d/node.json
  fi
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
writeConsulNodeConfig

sudo service consul restart
