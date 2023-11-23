package gatewayy

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
	"github.com/hyperledger/fabric-sdk-go/pkg/core/config"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
)

type Gatewayy struct {
	Db       *sql.DB
	Contract *gateway.Contract
	Network  *gateway.Network
	Wallet   *gateway.Wallet
}

type RequestGateway struct {
	Id                string
	Tanggal_Diolah    string
	Alamat_Perusahaan string
	Jumlah            string
	Jenis_Beras       string
	Nama_Petani       string
	Alamat            string
	Tanggal_Panen     string
}

func (gate *Gatewayy) ConnectToGateway(ctx *gin.Context) {
	var err error
	gate.Wallet, err = gateway.NewFileSystemWallet("wallet")
	if err != nil {
		log.Fatalf("Failed to create wallet: %v", err)
	}
	// err = gate.populateWallet()
	// if err != nil {
	// 	log.Fatalf("Failed to create Profile: %v", err)
	// }
	var ccpPath string
	var WalletAccount string
	baru := ctx.GetString("Organization")
	if baru == "farmer" {
		ccpPath = filepath.Join(
			"config",
			"connection-farmer.json",
		)
		WalletAccount = "Akunfarmer1"
	}
	if baru == "distributor" {
		ccpPath = filepath.Join(
			"config",
			"connection-distributor.json",
		)
		WalletAccount = "Akundistributor1"
	}
	if baru == "retailer" {
		ccpPath = filepath.Join(
			"config",
			"connection-retailer.json",
		)
		WalletAccount = "Akunretailer1"
	}
	if baru == "wholesaler" {
		ccpPath = filepath.Join(
			"config",
			"connection-wholesaler.json",
		)
		WalletAccount = "Akunwholesaler1"
	}
	if baru == "manufacturer" {
		ccpPath = filepath.Join(
			"config",
			"connection-manufacturer.json",
		)
		WalletAccount = "Akunmanufacturer1"
	}
	if baru == "consumer" {
		ccpPath = filepath.Join(
			"config",
			"connection-consumer.json",
		)
		WalletAccount = "Akunconsumer1"
	}

	gw, err := gateway.Connect(
		gateway.WithConfig(config.FromFile(filepath.Clean(ccpPath))),
		gateway.WithIdentity(gate.Wallet, WalletAccount),
	)
	if err != nil {
		log.Fatalf("Gagal Connect Ke Gateway: %v", err)
	}
	gate.Network, err = gw.GetNetwork("mychannel")
	if err != nil {
		// log.Fatalf("Failed to get network: %v", err)
		log.Fatalf("Gagal Connect Ke Network: %v", err)
	}
	gate.Contract = gate.Network.GetContract("scberas")
	defer gw.Close()
}

func (gate *Gatewayy) AssetTransfer(ctx *gin.Context) {
	var req = RequestGateway{}

	if err := ctx.ShouldBind(&req); err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"Error": err.Error(),
		})
		return
	}
	result, err := gate.Contract.SubmitTransaction("TransferAsset", req.Id, req.Tanggal_Diolah, req.Alamat_Perusahaan, req.Jumlah)

	if err != nil {
		log.Fatalf("Gagal dalam submit transaksi: %v", err)
		// println("Gagal Dalam Submit Transaksi: %v", err)
	}

	ctx.JSON(http.StatusOK, gin.H{
		"result": string(result),
	})

}
func (gate *Gatewayy) CreateAsset(ctx *gin.Context) {
	var req = RequestGateway{}

	if err := ctx.ShouldBind(&req); err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"Error": err.Error(),
		})
		return
	}
	result, err := gate.Contract.SubmitTransaction("CreateAssets", req.Id, req.Jenis_Beras, req.Nama_Petani, req.Alamat, req.Tanggal_Panen)
	if err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadGateway, gin.H{
			"Errorki": err.Error(),
		})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{
		"result": string(result),
	})
}

func (gate *Gatewayy) ReadAsset(ctx *gin.Context) {
	var req = RequestGateway{}
	var resultbaru map[string]interface{}
	if err := ctx.ShouldBind(&req); err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"Error": err.Error(),
		})
		return
	}
	result, err := gate.Contract.EvaluateTransaction("ReadAsset", req.Id)
	if err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadGateway, gin.H{
			"Errorki": err.Error(),
		})
		return
	}
	err = json.Unmarshal(result, &resultbaru)
	if err != nil {
		println("error")
	}
	ctx.JSON(http.StatusOK, gin.H{
		"result": resultbaru,
	})

}

func (gate *Gatewayy) LockAsset(ctx *gin.Context) {
	var req = RequestGateway{}
	// var resultbaru map[string]interface{}
	if err := ctx.ShouldBind(&req); err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadRequest, gin.H{
			"Error": err.Error(),
		})
		return
	}
	result, err := gate.Contract.SubmitTransaction("lockAsset", req.Id)
	if err != nil {
		ctx.AbortWithStatusJSON(http.StatusBadGateway, gin.H{
			"Errorki": err.Error(),
		})
		return
	}
	// err = json.Unmarshal(result, &resultbaru)
	// if err != nil {
	// 	println("error")
	// }

	ctx.JSON(http.StatusOK, gin.H{
		"result": string(result),
	})
}
func (gate *Gatewayy) populateWallet() error {
	credPath := filepath.Join(
		"..",
		"artifacts",
		"channel",
		"crypto-config",
		"peerOrganizations",
		"retailer.example.com",
		"users",
		"User1@retailer.example.com",
		"msp",
	)

	certPath := filepath.Join(credPath, "signcerts", "cert.pem")
	// read the certificate pem
	cert, err := os.ReadFile(filepath.Clean(certPath))
	if err != nil {
		return err
	}

	keyDir := filepath.Join(credPath, "keystore")
	// there's a single file in this dir containing the private key
	files, err := os.ReadDir(keyDir)
	if err != nil {
		return err
	}
	if len(files) != 1 {
		return fmt.Errorf("keystore folder should have contain one file")
	}
	keyPath := filepath.Join(keyDir, files[0].Name())
	key, err := os.ReadFile(filepath.Clean(keyPath))
	if err != nil {
		return err
	}

	identity := gateway.NewX509Identity("retailerMSP", string(cert), string(key))

	return gate.Wallet.Put("Akunretailer1", identity)
}
