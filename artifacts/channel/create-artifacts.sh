
# Delete existing artifacts
# rm genesis.block mychannel.tx
# rm -rf ../../channel-artifacts/*

Generate Crypto artifactes for organizations
cryptogen generate --config=./crypto-config.yaml --output=./crypto-config/



# System channel
SYS_CHANNEL="sys-channel"

# channel name defaults to "mychannel"
CHANNEL_NAME="mychannel"

echo $CHANNEL_NAME

# Generate System Genesis block
configtxgen -profile OrdererGenesis -configPath . -channelID $SYS_CHANNEL  -outputBlock ./genesis.block


# Generate channel configuration block
configtxgen -profile BasicChannel -configPath . -outputCreateChannelTx ./$CHANNEL_NAME.tx -channelID $CHANNEL_NAME

echo "#######    Generating anchor peer update for Org1MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./farmerMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg farmerMSP

echo "#######    Generating anchor peer update for Org2MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./consumerMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg consumerMSP

echo "#######    Generating anchor peer update for Org3MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./distributorMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg distributorMSP

echo "#######    Generating anchor peer update for Org4MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./manufacturerMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg manufacturerMSP

echo "#######    Generating anchor peer update for Org5MSP  ##########"
configtxgen -profile BasicChannel -configPath . -outputAnchorPeersUpdate ./wholesalerMSPAnchor.tx -channelID $CHANNEL_NAME -asOrg wholesalerMSP
