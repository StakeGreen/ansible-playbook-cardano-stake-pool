#!/bin/bash

cardano-cli query utxo \
    --address $(cat $KEYS_DIR/payment.addr) \
    --mainnet > $WORKING_DIR/fullUtxo.out

tail -n +3 $WORKING_DIR/fullUtxo.out | sort -k3 -nr > $WORKING_DIR/balance.out

cat $WORKING_DIR/balance.out

tx_in=""
total_balance=0
while read -r utxo; do
    in_addr=$(awk '{ print $1 }' <<< "${utxo}")
    idx=$(awk '{ print $2 }' <<< "${utxo}")
    utxo_balance=$(awk '{ print $3 }' <<< "${utxo}")
    total_balance=$((${total_balance}+${utxo_balance}))
    echo TxHash: ${in_addr}#${idx}
    echo ADA: ${utxo_balance}
    tx_in="${tx_in} --tx-in ${in_addr}#${idx}"
done < $WORKING_DIR/balance.out
txcnt=$(cat $WORKING_DIR/balance.out | wc -l)
echo Total ADA balance: ${total_balance}
echo Number of UTXOs: ${txcnt}
