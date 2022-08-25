#!/bin/bash
source /home/deploy/env_vars.sh
cardano-cli node key-gen-VRF \
    --verification-key-file $WORKING_DIR/vrf.vkey \
    --signing-key-file $WORKING_DIR/vrf.skey
