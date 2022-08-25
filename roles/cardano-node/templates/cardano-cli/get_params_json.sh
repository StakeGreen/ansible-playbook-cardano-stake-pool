#!/bin/bash
cardano-cli query protocol-parameters \
    --mainnet \
    --out-file $WORKING_DIR/params.json
