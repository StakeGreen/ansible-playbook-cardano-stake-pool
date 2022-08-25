#!/bin/bash

tx_out_count=$1
witness_count=$2

fee=$(cardano-cli transaction calculate-min-fee \
    --tx-body-file $WORKING_DIR/tx.tmp \
    --tx-in-count ${txcnt} \
    --tx-out-count ${tx_out_count} \
    --mainnet \
    --witness-count ${witness_count} \
    --byron-witness-count 0 \
    --protocol-params-file $WORKING_DIR/params.json | awk '{ print $1 }')
echo fee: $fee
