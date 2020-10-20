#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# Set env vars
export PATH=~/Desktop/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=allarewelcome

# Remove previous crypto material and config transactions
mkdir -p config
rm -fr config/*
rm -fr crypto-config/*

# Generate crypto material
cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

# Generate genesis block for orderer
configtxgen -profile OneOrgOrdererGenesis -channelID system-channel -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# Generate channel configuration transaction
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# Generate anchor peer transaction
configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi

sleep 5s

set -ev

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com

# Wait for Hyperledger Fabric to start
# In case of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=15
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the application channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/$CHANNEL_NAME.tx
# Join peer0.org1.example.com to the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b $CHANNEL_NAME.block
