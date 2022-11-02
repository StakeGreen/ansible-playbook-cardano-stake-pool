#!/bin/bash
source ~/env_vars.sh
cardano-cli transaction submit --tx-file $WORKING_DIR/tx.signed --mainnet
