#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

# ORG='farmer'
# P0PORT=7051
# CAPORT=7054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/tls-localhost-7054-ca-farmer-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM )" > connection-org1.json

# ORG='distributor'
# P0PORT=9051
# CAPORT=8054
# PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/tlscacerts/tls-localhost-8054-ca-distributor-example-com.pem
# CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/distributor.example.com/msp/tlscacerts/ca.crt

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-org2.json

ORG='consumer'
P0PORT=8051
CAPORT=10054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/tlscacerts/tls-localhost-10054-ca-consumer-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/consumer.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-consumer.json

ORG='wholesaler'
P0PORT=5551
CAPORT=2054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/tlscacerts/tls-localhost-2054-ca-wholesaler-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/wholesaler.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-wholesaler.json

ORG='retailer'
P0PORT=6551
CAPORT=1054
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/retailer.example.com/peers/peer0.retailer.example.com/tls/tlscacerts/tls-localhost-1054-ca-retailer-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/retailer.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-retailer.json

ORG='manufacturer'
P0PORT=9551
CAPORT=1056
PEERPEM=../../artifacts/channel/crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/tlscacerts/tls-localhost-1056-ca-manufacturer-example-com.pem
CAPEM=../../artifacts/channel/crypto-config/peerOrganizations/manufacturer.example.com/msp/tlscacerts/ca.crt


echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > connection-manufacturer.json