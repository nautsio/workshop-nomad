#!/bin/bash
MACHINE_PREFIX=$1
MACHINE_ID=$2
NUM_INSTANCES=$3
BASE_ADDRESS=$4

BASE_OCTET1_3=$(echo $BASE_ADDRESS | cut -d. -f1-3)
BASE_OCTET4=$(echo $BASE_ADDRESS | cut -d. -f4)

function nodeNumberToAddress {
  echo "${BASE_OCTET1_3}.$((${BASE_OCTET4} + $1))"
}

NAME=$(printf "%s-%02d" $MACHINE_PREFIX $MACHINE_ID)
BIND_ADDR="$(nodeNumberToAddress $MACHINE_ID)"

function writeNomadNodeConfig {
  printf 'name="%s"\nbind_addr="%s"\n' $NAME $BIND_ADDR > /etc/nomad.d/node.hcl
}

function writeConsulNodeConfig {
  (
    if [ $MACHINE_ID == 1 ]; then
      printf '{"bootstrap": true, "bind_addr": "%s", "client_addr": "%s"}' $BIND_ADDR $BIND_ADDR
    else
      printf '{"start_join": ["%s"], "bind_addr": "%s", "client_addr": "%s"}' $(nodeNumberToAddress 1) $BIND_ADDR $BIND_ADDR
    fi
  ) | jq . > /etc/consul.d/node.json
}

function writeHostsFile {
  (
    printf "%-15s %s\n" 127.0.0.1 localhost
    for i in $(seq $NUM_INSTANCES); do
      printf "%-15s %s-%02d\n" $(nodeNumberToAddress $i) $MACHINE_PREFIX $i
    done
  ) > /etc/hosts
}

writeHostsFile
writeNomadNodeConfig
writeConsulNodeConfig

sudo service consul restart
