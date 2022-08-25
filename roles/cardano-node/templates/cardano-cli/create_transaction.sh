#!/bin/bash

if [ $# -eq 2 ]; then
    echo "Your command line contains $# arguments"
else
    echo "Error: Your command line contains no arguments"
    exit 1
fi

amount_to_send=$1
sender_address=$2

source ~/env_vars.sh
source ./get_params_json.sh
source ./find_tip_of_blockchain.sh
source ./find_balance_and_utxos.sh

cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out $(cat /opt/cardano/cnode/keys/payment.addr)+0 \
    --tx-out $(cat /opt/cardano/cnode/keys/payment.addr)+0 \
    --invalid-hereafter 0 \
    --fee 0 \
    --out-file $WORKING_DIR/tx.tmp

source ./calculate_minimum_fee.sh 2 3

txOut=$(( ${total_balance}-${amount_to_send}-${fee} ))

echo "Total balance ${total_balance}"
echo "Amount ${amount_to_send} sending out to external address ${sender_address}"
echo "Amount ${txOut} send to change address $(cat /opt/cardano/cnode/keys/payment.addr)"

cardano-cli transaction build-raw \
    ${tx_in} \
    --tx-out ${sender_address}+${amount_to_send} \
    --tx-out $(cat /opt/cardano/cnode/keys/payment.addr)+${txOut} \
    --invalid-hereafter $(( ${currentSlot} + 10000 )) \
    --fee ${fee} \
    --out-file $WORKING_DIR/tx.raw
