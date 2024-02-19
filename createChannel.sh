export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_farmer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER0_distributor_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/ca.crt
export PEER0_consumer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/ca.crt
export PEER0_manufacturer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/ca.crt
export PEER0_retailer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/retailer.example.com/peers/peer0.retailer.example.com/tls/ca.crt
export PEER0_wholesaler_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/config/

export CHANNEL_NAME=mychannel

setGlobalsForPeer0farmer(){
    export CORE_PEER_LOCALMSPID="farmerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_farmer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForPeer0distributor(){
    export CORE_PEER_LOCALMSPID="distributorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_distributor_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/distributor.example.com/users/Admin@distributor.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
    
}

setGlobalsForPeer0consumer(){
    export CORE_PEER_LOCALMSPID="consumerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_consumer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/consumer.example.com/users/Admin@consumer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:8051
    
}

setGlobalsForPeer0manufacturer(){
    export CORE_PEER_LOCALMSPID="manufacturerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_manufacturer_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manufacturer.example.com/users/Admin@manufacturer.example.com/msp
    export CORE_PEER_ADDRESS=localhost:9551
    
}



setGlobalsForPeer0wholesaler(){
    export CORE_PEER_LOCALMSPID="wholesalerMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_wholesaler_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/wholesaler.example.com/users/Admin@wholesaler.example.com/msp
    export CORE_PEER_ADDRESS=localhost:5551
    
}

createChannel(){
    rm -rf ./channel-artifacts/*
    setGlobalsForPeer0farmer
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.example.com \
    -f ./artifacts/channel/${CHANNEL_NAME}.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

removeOldCrypto(){
    rm -rf ./api-1.4/crypto/*
    rm -rf ./api-1.4/fabric-client-kv-org1/*
    rm -rf ./api-2.0/org1-wallet/*
    rm -rf ./api-2.0/org2-wallet/*
}


joinChannel(){
    setGlobalsForPeer0farmer
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    
    setGlobalsForPeer0distributor
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
    setGlobalsForPeer0manufacturer
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    setGlobalsForPeer0consumer
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block

    

    setGlobalsForPeer0wholesaler
    peer channel join -b ./channel-artifacts/$CHANNEL_NAME.block
    
}

updateAnchorPeers(){
    setGlobalsForPeer0farmer
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForPeer0distributor
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0consumer
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    

    setGlobalsForPeer0wholesaler
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA

    setGlobalsForPeer0manufacturer
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com -c $CHANNEL_NAME -f ./artifacts/channel/${CORE_PEER_LOCALMSPID}Anchor.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
}

# removeOldCrypto

createChannel
joinChannel
updateAnchorPeers