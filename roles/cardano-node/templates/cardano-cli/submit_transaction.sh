#!/bin/bash
cardano-cli transaction submit --tx-file $WORKING_DIR/tx.signed --mainnet
