#!/bin/bash
cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat $KEYS_DIR/payment.addr)+${txOut} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee ${fee} \
    --certificate-file $KEYS_DIR/pool.cert \
    --certificate-file $KEYS_DIR/deleg.cert \
    --out-file $WORKING_DIR/tx.raw
