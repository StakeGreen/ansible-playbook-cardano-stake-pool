#!/bin/bash
source ~/.bashrc

cardano-cli query kes-period-info \
    --mainnet \
    --op-cert-file ${KEYS_DIR}/node.cert
