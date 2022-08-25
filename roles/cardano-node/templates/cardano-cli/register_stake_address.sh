#!/bin/bash

echo 'Sourcing env vars'
source /home/deploy/env_vars.sh
source ./find_tip_of_blockchain.sh
source ./find_balance_and_utxos.sh
source ./find_stake_address_deposit_value.sh

cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat $KEYS_DIR/payment.addr)+0 \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee 0 \
    --out-file $WORKING_DIR/tx.tmp \
    --certificate $KEYS_DIR/stake.cert

source ./calculate_minimum_fee.sh 1 2

txOut=$((${total_balance}-${stakeAddressDeposit}-${fee}))
echo Change Output: ${txOut}

cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat $KEYS_DIR/payment.addr)+${txOut} \
    --invalid-hereafter $(( ${currentSlot} + 10000)) \
    --fee ${fee} \
    --certificate-file $KEYS_DIR/stake.cert \
    --out-file $WORKING_DIR/tx.raw

