createcertificatesForFarmer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/farmer.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name farmeradmin --id.secret farmeradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp --csr.hosts peer0.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls --enrollment.profile tls --csr.hosts peer0.farmer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca/tlsca.farmer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca/ca.farmer.example.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://farmeradmin:farmeradminpw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp/config.yaml

}
createcertificatesForFarmerLain() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/farmer.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-farmer-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name peer1 --id.secret peer1pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register user"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name user2 --id.secret user2pw --id.type client --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  echo
  echo "Register the org admin"
  echo
  fabric-ca-client register --caname ca.farmer.example.com --id.name farmeradmin --id.secret farmeradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers

  # -----------------------------------------------------------------------------------
  #  Peer 0
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com

  echo
  echo "## Generate the peer1 msp"
  echo
  fabric-ca-client enroll -u https://peer1:peer1pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/msp --csr.hosts peer1.farmer.example.com --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  fabric-ca-client enroll -u https://peer1:peer0pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls --enrollment.profile tls --csr.hosts peer1.farmer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer1.farmer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/tlsca/tlsca.farmer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/peers/peer0.farmer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/ca/ca.farmer.example.com-cert.pem

  # --------------------------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com

  echo
  echo "## Generate the user msp"
  echo
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/User1@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://farmeradmin:farmeradminpw@localhost:7054 --caname ca.farmer.example.com -M ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/farmer/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/farmer.example.com/users/Admin@farmer.example.com/msp/config.yaml

}

# createcertificatesForOrg1

createCertificatesForDistributor() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/distributor.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/distributor.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.distributor.example.com --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-distributor-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/distributor.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.distributor.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.distributor.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.distributor.example.com --id.name distributoradmin --id.secret distributoradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/distributor.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.distributor.example.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/msp --csr.hosts peer0.distributor.example.com --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.distributor.example.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls --enrollment.profile tls --csr.hosts peer0.distributor.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/tlsca/tlsca.distributor.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/peers/peer0.distributor.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/ca/ca.distributor.example.com-cert.pem

  # --------------------------------------------------------------------------------
 
  mkdir -p ../crypto-config/peerOrganizations/distributor.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/distributor.example.com/users/User1@distributor.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.distributor.example.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/users/User1@distributor.example.com/msp --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/distributor.example.com/users/Admin@distributor.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://distributoradmin:distributoradminpw@localhost:8054 --caname ca.distributor.example.com -M ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/users/Admin@distributor.example.com/msp --tls.certfiles ${PWD}/fabric-ca/distributor/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/distributor.example.com/users/Admin@distributor.example.com/msp/config.yaml

}

createCertificatesForManufacturer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:1056 --caname ca.manufacturer.example.com --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-1056-ca-manufacturer-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-1056-ca-manufacturer-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-1056-ca-manufacturer-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-1056-ca-manufacturer-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.manufacturer.example.com --id.name manufactureradmin --id.secret manufactureradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1056 --caname ca.manufacturer.example.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/msp --csr.hosts peer0.manufacturer.example.com --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:1056 --caname ca.manufacturer.example.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls --enrollment.profile tls --csr.hosts peer0.manufacturer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/tlsca/tlsca.manufacturer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/peers/peer0.manufacturer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/ca/ca.manufacturer.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/users/User1@manufacturer.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:1056 --caname ca.manufacturer.example.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/users/User1@manufacturer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/manufacturer.example.com/users/Admin@manufacturer.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://manufactureradmin:manufactureradminpw@localhost:1056 --caname ca.manufacturer.example.com -M ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/users/Admin@manufacturer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/manufacturer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/manufacturer.example.com/users/Admin@manufacturer.example.com/msp/config.yaml

}

# createCertificateForOrg2

createCertificatesForConsumer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/consumer.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca.consumer.example.com --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-consumer-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-consumer-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-consumer-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-consumer-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/consumer.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.consumer.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.consumer.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.consumer.example.com --id.name consumeradmin --id.secret consumeradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.consumer.example.com -M ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/msp --csr.hosts peer0.consumer.example.com --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca.consumer.example.com -M ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls --enrollment.profile tls --csr.hosts peer0.consumer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/tlsca/tlsca.consumer.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/peers/peer0.consumer.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/ca/ca.consumer.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/users/User1@consumer.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca.consumer.example.com -M ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/users/User1@consumer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/consumer.example.com/users/Admin@consumer.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://consumeradmin:consumeradminpw@localhost:10054 --caname ca.consumer.example.com -M ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/users/Admin@consumer.example.com/msp --tls.certfiles ${PWD}/fabric-ca/consumer/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/consumer.example.com/users/Admin@consumer.example.com/msp/config.yaml

}

createCertificatesForWholesaler() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:2054 --caname ca.wholesaler.example.com --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-wholesaler-example-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-wholesaler-example-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-wholesaler-example-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-2054-ca-wholesaler-example-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/msp/config.yaml

  echo
  echo "Register peer0"
  echo
   
  fabric-ca-client register --caname ca.wholesaler.example.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  echo
  echo "Register user"
  echo
   
  fabric-ca-client register --caname ca.wholesaler.example.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  echo
  echo "Register the org admin"
  echo
   
  fabric-ca-client register --caname ca.wholesaler.example.com --id.name wholesaleradmin --id.secret wholesaleradminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/peers
  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com

  # --------------------------------------------------------------
  # Peer 0
  echo
  echo "## Generate the peer0 msp"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca.wholesaler.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/msp --csr.hosts peer0.wholesaler.example.com --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:2054 --caname ca.wholesaler.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls --enrollment.profile tls --csr.hosts peer0.wholesaler.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/tlsca/tlsca.wholesaler.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/peers/peer0.wholesaler.example.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/ca/ca.wholesaler.example.com-cert.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/users
  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/users/User1@wholesaler.example.com

  echo
  echo "## Generate the user msp"
  echo
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:2054 --caname ca.wholesaler.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/users/User1@wholesaler.example.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  mkdir -p ../crypto-config/peerOrganizations/wholesaler.example.com/users/Admin@wholesaler.example.com

  echo
  echo "## Generate the org admin msp"
  echo
   
  fabric-ca-client enroll -u https://wholesaleradmin:wholesaleradminpw@localhost:2054 --caname ca.wholesaler.example.com -M ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/users/Admin@wholesaler.example.com/msp --tls.certfiles ${PWD}/fabric-ca/wholesaler/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/wholesaler.example.com/users/Admin@wholesaler.example.com/msp/config.yaml

}

createCretificatesForOrderer() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p ../crypto-config/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/example.com

   
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml

  echo
  echo "Register orderer"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   
   

  echo
  echo "Register the orderer admin"
  echo
   
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers
  # mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/example.com

  # ---------------------------------------------------------------------------
  #  Orderer

  mkdir -p ../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/example.com/users
  mkdir -p ../crypto-config/ordererOrganizations/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:9054 --caname ca-orderer -M ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/fabric-ca/ordererOrg/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/example.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}

# createCretificateForOrderer

# sudo rm -rf ../crypto-config/*
# sudo rm -rf fabric-ca/*
createcertificatesForFarmer
createCertificatesForDistributor
createCertificatesForManufacturer
createCertificatesForConsumer
createCertificatesForWholesaler
createCretificatesForOrderer

