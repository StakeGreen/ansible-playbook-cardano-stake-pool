#!/usr/bin/env bash

if [ $1 = 'current' ]; then
  echo 'Calculating leaderlog for current epoch'
elif [ $1 = 'next' ]; then
  echo 'Calculating leaderlog for next epoch'
else
  echo "Error: Your command line contains no arguments. You have to add current or next to the command"
  exit 1
fi

source ~/env_vars.sh
argument=$1
outputFile=${CNODE_HOME}/scripts/leadership-schedule-${argument}."\$(date +%F-%H%M%S)".log

cardano-cli query leadership-schedule \
--mainnet \
--genesis ${SHELLEY_GENESIS_JSON} \
--stake-pool-id $(cat ${KEYS_DIR}/stakepoolid.txt) \
--vrf-signing-key-file ${KEYS_DIR}/vrf.skey \
--${argument} > ${WORKING_DIR}/leadership-schedule-${argument}.log

mv ${WORKING_DIR}/leadership-schedule-${argument}.log ${WORKING_DIR}/leadership-schedule-${argument}.$(date +%F-%H%M%S).log
