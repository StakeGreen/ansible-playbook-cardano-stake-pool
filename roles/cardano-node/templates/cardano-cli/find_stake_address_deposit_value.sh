#!/bin/bash
stakeAddressDeposit=$(cat $WORKING_DIR/params.json | jq -r '.stakeAddressDeposit')
echo stakeAddressDeposit : $stakeAddressDeposit
