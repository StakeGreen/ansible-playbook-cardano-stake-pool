#!/bin/bash

source /home/deploy/env_vars.sh

cardano-cli query stake-address-info \
 --address $(cat $KEYS_DIR/stake.addr) \
 --mainnet
