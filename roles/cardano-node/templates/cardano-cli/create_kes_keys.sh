#!/bin/bash
source ~/.bashrc
cardano-cli node key-gen-KES \
    --verification-key-file $WORKING_DIR/kes.vkey \
    --signing-key-file $WORKING_DIR/kes.skey
