#!/bin/bash
cardano-cli query stake-snapshot --mainnet --stake-pool-id $(cat $KEYS_DIR/stakepoolid.txt)
