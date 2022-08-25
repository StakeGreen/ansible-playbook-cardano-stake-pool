#!/bin/bash

source /home/deploy/env_vars.sh

echo 'Get params'
source ${CNODE_HOME}/scripts/cardano-cli/get_params_json.sh

# If you do a change of the registration you don\'t need to add the deposit so set to 0
if [ $1 = 'first' ]; then
    echo 'Get stake pool deposit'
    stakePoolDeposit=$(cat $WORKING_DIR/params.json | jq -r '.stakePoolDeposit')
    echo stakePoolDeposit: $stakePoolDeposit
elif [ $1 = 'second' ]; then
    stakePoolDeposit=0
else
    echo "Error: Your command line contains no arguments. If this is the first registration run the command with './register_stake_pool.sh first' otherwise './register_stake_pool.sh second'"
    exit 1
fi

echo 'Sourcing env vars'
source /home/deploy/env_vars.sh
echo 'Find tip of blockchain'
source ${CNODE_HOME}/scripts/cardano-cli/find_tip_of_blockchain.sh
echo 'Find balance and utxos'
source ${CNODE_HOME}/scripts/cardano-cli/find_balance_and_utxos.sh

echo 'Create tmp transaction'
source ${CNODE_HOME}/scripts/cardano-cli/create_tmp_transaction_stake_pool_registration.sh ${stakePoolDeposit}
echo 'Calculate minimum transaction'
source ${CNODE_HOME}/scripts/cardano-cli/calculate_minimum_fee.sh 1 3
echo 'Calculate tx out'
txOut=$((${total_balance}-${stakePoolDeposit}-${fee}))
echo txOut: ${txOut}
echo 'Create raw transaction'
source ${CNODE_HOME}/scripts/cardano-cli/create_raw_transaction_stake_pool_registration.sh
