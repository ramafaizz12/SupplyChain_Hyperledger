# export CORE_PEER_TLS_ENABLED=true
# export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
# export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
# export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
# export PEER0_ORG3_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt
# export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

# export CHANNEL_NAME=mychannel

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_farmer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
export PEER0_distributor_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/ca.crt
export PEER0_consumer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/ca.crt
export PEER0_manufacturer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/ca.crt
export PEER0_retailer_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/retailer.example.com/peers/peer0.retailer.example.com/tls/ca.crt
export PEER0_wholesaler_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export CHANNEL_NAME=mychannel

setGlobalsForOrderer() {
    export CORE_PEER_LOCALMSPID="OrdererMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp

}

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

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./artifacts/src/github.com/scberas/go
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}
# presetup
PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
SEQUENCE=1
CC_SRC_PATH="./artifacts/src/github.com/scberas/go"
CC_NAME="scberas"


packageChaincode() {
    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForPeer0farmer
    peer lifecycle chaincode package ${CC_NAME}.tar.gz \
        --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} \
        --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged ===================== "
}
# packageChaincode

installChaincode() {
    setGlobalsForPeer0farmer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org1 ===================== "

    setGlobalsForPeer0distributor
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org2 ===================== "

    setGlobalsForPeer0consumer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org3 ===================== "

     setGlobalsForPeer0manufacturer
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org4 ===================== "

     

     setGlobalsForPeer0wholesaler
    peer lifecycle chaincode install ${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.org6 ===================== "
}

commitchaincodebaru (){
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com --tls --cafile ${ORDERER_CA} --channelID mychannel --name fabcar --peerAddresses localhost:7051 --tlsRootCertFiles ${farmerMSP}  --version 1.0  -n --sequence 1
}
# installChaincode

queryInstalled() {
    setGlobalsForPeer0farmer
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.org1 on channel ===================== "
}

# queryInstalled



approveForMyOrg1() {
    setGlobalsForPeer0farmer
   
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
         --version ${VERSION}    --init-required --package-id ${PACKAGE_ID}  --sequence 1
          
    # # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}
# queryInstalled
# approveForMyOrg1

# --signature-policy "OR ('Org1MSP.member')"
# --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA
# --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --peerAddresses peer0.org2.example.com:9051 --tlsRootCertFiles $PEER0_ORG2_CA
#--channel-config-policy Channel/Application/Admins
# --signature-policy "OR ('Org1MSP.peer','Org2MSP.peer')"

checkCommitReadyness() {
    setGlobalsForPeer0farmer
    peer lifecycle chaincode checkcommitreadiness \
        --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${VERSION} \
        --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

approveForMyOrg2() {
    setGlobalsForPeer0distributor
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
         --version ${VERSION}    --init-required --package-id ${PACKAGE_ID}  --sequence 1
          
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

# queryInstalled
# approveForMyOrg2

checkCommitReadyness() {

    setGlobalsForPeer0distributor
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

approveForMyOrg3() {
    setGlobalsForPeer0consumer
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
         --version ${VERSION}    --init-required --package-id ${PACKAGE_ID}  --sequence 1
          
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

# queryInstalled
# approveForMyOrg3

checkCommitReadyness() {

    setGlobalsForPeer0consumer
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

approveForMyOrg4() {
    setGlobalsForPeer0manufacturer
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
         --version ${VERSION}    --init-required --package-id ${PACKAGE_ID}  --sequence 1
          
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

checkCommitReadyness() {

    setGlobalsForPeer0manufacturer
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}



approveForMyOrg6() {
    setGlobalsForPeer0wholesaler
    # set -x
    peer lifecycle chaincode approveformyorg -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com --tls \
        --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} \
         --version ${VERSION}    --init-required --package-id ${PACKAGE_ID}  --sequence 1
          
    # set +x

    echo "===================== chaincode approved from org 1 ===================== "

}

checkCommitReadyness() {

    setGlobalsForPeer0wholesaler
    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
        --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
        --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required
    echo "===================== checking commit readyness from org 1 ===================== "
}

# checkCommitReadyness

commitChaincodeDefination() {
    setGlobalsForPeer0farmer
    peer lifecycle chaincode commit -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        --channelID $CHANNEL_NAME --name ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
         --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
         --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
           --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
            --version ${VERSION} --sequence ${SEQUENCE} --init-required
}

createcollectiondata() {
    setGlobalsForPeer0farmer
    setGlobalsForOrderer
    peer chaincode instantiate -C $CHANNEL_NAME \
                                --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
                                --collections-config ./artifacts/private-data/collections_config.json \
                                -P "OR('Org1MSP.member','Org2MSP.member')"
}
# commitChaincodeDefination


queryCommitted() {
    setGlobalsForPeer0farmer
    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}

}

# queryCommitted

chaincodeInvokeInit() {
    setGlobalsForPeer0farmer
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
        --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
       --isInit -c '{"Args":[]}'
     
       

}

# chaincodeInvokeInit

chaincodeInvoke() {
    setGlobalsForPeer0farmer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
        --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
         -c '{"function":"InitLedger","Args":[]}'
         

}

# chaincodeInvoke

chaincodeInvokeDeleteAsset() {
    setGlobalsForPeer0farmer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        -c '{"function": "DeleteCarById","Args":["2"]}'

}

chaincodeUpdateAsset() {
    setGlobalsForPeer0manufacturer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
        --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
        -c '{"function": "TransferAssetToDistributor","Args":["asset4", "200 ton", "3bulan", "1 minggu", "25%", "10 %", "20 kg", "2%", "2%", "4%"]}'

}
chaincodeLockAsset() {
    setGlobalsForPeer0manufacturer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
        --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        -c '{"function": "lockAsset","Args":["asset1"]}'
        # --peerAddresses localhost:6551 --tlsRootCertFiles $PEER0_retailer_CA \
        # --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
        

}
chaincodeCreateAsset() {
    setGlobalsForPeer0farmer

    # Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_farmer_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_distributor_CA \
        --peerAddresses localhost:8051 --tlsRootCertFiles $PEER0_consumer_CA \
         -c '{"function": "CreateAssets","Args":["asset4", "Beras Ketan", "farhan", "jl.baruga raya", "12-12-2023", "081342073769", "9999999"]}'
        # --peerAddresses localhost:9551 --tlsRootCertFiles $PEER0_manufacturer_CA \
        # --peerAddresses localhost:6551 --tlsRootCertFiles $PEER0_retailer_CA \
         
        # --peerAddresses localhost:5551 --tlsRootCertFiles $PEER0_wholesaler_CA \
       

}

# chaincodeInvokeDeleteAsset

chaincodeQuery() {
    setGlobalsForPeer0farmer
    # setGlobalsForOrg1
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function": "GetAllAssets","Args":[]}'
}


checkinstallpacakage (){
    setGlobalsForPeer0farmer
    peer lifecycle chaincode getinstalledpackage --package-id ${PACKAGE_ID}
}
# chaincodeQuery

# Run this function if you add any new dependency in chaincode
# presetup

# packageChaincode
# installChaincode

# queryInstalled
# checkinstallpacakage
# approveForMyOrg1


# sleep 3
# checkCommitReadyness
# approveForMyOrg2
# sleep 3
# checkCommitReadyness
approveForMyOrg3
sleep 3
checkCommitReadyness
approveForMyOrg4
sleep 3
checkCommitReadyness
approveForMyOrg6
sleep 3
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
sleep 5
chaincodeInvoke
sleep 3
chaincodeQuery
# chaincodeUpdateAsset
# chaincodeCreateAsset
# chaincodeLockAsset
# export PATH=${PWD}/bin:$PATH