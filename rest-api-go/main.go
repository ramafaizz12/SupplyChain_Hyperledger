package main

import (
	"fmt"

	"github.com/fabric_network/rest-api-go/web"
)

func main() {
	//Initialize setup for Org1
	cryptoPath := "../../test-network/organizations/peerOrganizations/farmer.supplychain.com"
	orgConfig := web.OrgSetup{
		OrgName:      "farmer",
		MSPID:        "farmerMSP",
		CertPath:     cryptoPath + "/users/User1@farmer.supplychain.com/msp/signcerts/cert.pem",
		KeyPath:      cryptoPath + "/users/User1@farmer.supplychain.com/msp/keystore/",
		TLSCertPath:  cryptoPath + "/peers/peer0.farmer.supplychain.com/tls/ca.crt",
		PeerEndpoint: "localhost:7051",
		GatewayPeer:  "peer0.farmer.supplychain.com",
	}

	orgSetup, err := web.Initialize(orgConfig)
	if err != nil {
		fmt.Println("Error initializing setup for Org1: ", err)
	}
	web.Serve(web.OrgSetup(*orgSetup))
}
