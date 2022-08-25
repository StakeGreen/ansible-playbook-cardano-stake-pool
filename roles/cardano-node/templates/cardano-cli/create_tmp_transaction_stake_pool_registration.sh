#!/bin/bash

stake_pool_deposit=$1

cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat $KEYS_DIR/payment.addr)+$(( ${total_balance} - ${stake_pool_deposit} ))  \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee 0 \
    --certificate-file $KEYS_DIR/pool.cert \
    --certificate-file $KEYS_DIR/deleg.cert \
    --out-file $WORKING_DIR/tx.tmp
