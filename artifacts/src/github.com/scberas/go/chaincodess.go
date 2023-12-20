package main

import (
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract provides functions for managing an Asset
type SmartContract struct {
	contractapi.Contract
}

// Asset describes basic details of what makes up a simple asset
type Asset struct {
	ID                      string `json:"ID"`
	Nama_petani             string `json:"nama_petani"`
	Jenis_beras             string `json:"jenis_beras"`
	Owner                   string `json:"owner"`
	Alamat                  string `json:"alamat"`
	Tanggal_panen           string `json:"tanggal_panen"`
	Konfirmasi_manufacturer bool   `json:"konfirmasi_manufacturer"`
	Konfirmasi_distributor  bool   `json:"konfirmasi_distributor"`
	Konfirmasi_retailer     bool   `json:"konfirmasi_retailer"`
	Konfirmasi_wholesaler   bool   `json:"konfirmasi_wholesaler"`
	Tanggal_diolah          string `json:"tanggal_diolah"`
	Nohp                    string `json:"no_hp"`
	Npwp                    string `json:"npwp"`
	Alamat_perusahaan       string `json:"alamat_perusahaan"`
	JumlahToWholesaler      string `json:"jumlahToWholesaler"`
	JumlahToRetailer        string `json:"jumlahToRetailer"`
	TimeStamp               string `json:"timestamp"`
}

// CreateAsset issues a new asset to the world state with given details.
func (s *SmartContract) CreateAssets(ctx contractapi.TransactionContextInterface, id string, jenis_beras string, nama_petani string, alamat string, tanggal_panen string, nohp string, npwp string) error {
	exists, err := s.AssetExists(ctx, id)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("ID %s sudah ada", id)
	}

	clientorg, err := ctx.GetClientIdentity().GetMSPID()
	if clientorg != "farmerMSP" {
		return fmt.Errorf("Maaf anda bukan farmer")
	}
	if err != nil {
		return err
	}

	asset := Asset{
		ID:            id,
		Jenis_beras:   jenis_beras,
		Nama_petani:   nama_petani,
		Owner:         "manufacturerMSP",
		Alamat:        alamat,
		Nohp:          nohp,
		Npwp:          npwp,
		Tanggal_panen: tanggal_panen,
	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

// func (s *SmartContract) lockToken(ctx contractapi.TransactionContextInterface, tokenId string) [] byte {
// 	owner, err := ctx.GetClientIdentity().GetID()
// 	exists:= s.nftExist(ctx, tokenId)

// }

// ReadAsset returns the asset stored in the world state with given id.
func (s *SmartContract) ReadAsset(ctx contractapi.TransactionContextInterface, id string) (*Asset, error) {
	assetJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return nil, fmt.Errorf("failed to read from world state: %v", err)
	}
	if assetJSON == nil {
		return nil, fmt.Errorf("the asset %s does not exist", id)
	}

	var asset Asset
	err = json.Unmarshal(assetJSON, &asset)
	if err != nil {
		return nil, err
	}

	return &asset, nil
}

// UpdateAsset updates an existing asset in the world state with provided parameters.
func (s *SmartContract) UpdateAsset(ctx contractapi.TransactionContextInterface, id string, tanggal_diolah string, alamat_perusahaan string, konfirmasi bool, jumlah string, timestamp string) error {
	exists, err := s.AssetExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s does not exist", id)
	}
	asset := Asset{}
	// overwriting original asset with new asset
	clientorg, err := ctx.GetClientIdentity().GetMSPID()
	if clientorg == "manufacturerMSP" {
		asset = Asset{

			Tanggal_diolah:    tanggal_diolah,
			Alamat_perusahaan: alamat_perusahaan,
		}
	}
	if err != nil {
		return err
	}

	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

// DeleteAsset deletes an given asset from the world state.
func (s *SmartContract) DeleteAsset(ctx contractapi.TransactionContextInterface, id string) error {
	exists, err := s.AssetExists(ctx, id)
	if err != nil {
		return err
	}
	if !exists {
		return fmt.Errorf("the asset %s does not exist", id)
	}

	return ctx.GetStub().DelState(id)
}

// AssetExists returns true when asset with given ID exists in world state
func (s *SmartContract) AssetExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {
	assetJSON, err := ctx.GetStub().GetState(id)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return assetJSON != nil, nil
}

// TransferAsset updates the owner field of asset with given id in world state.
func (s *SmartContract) TransferAsset(ctx contractapi.TransactionContextInterface, id string, tanggal_diolah string, alamat_perusahaan string, jumlah string) error {
	asset, err := s.ReadAsset(ctx, id)
	if err != nil {
		return err
	}
	clientorg, err := ctx.GetClientIdentity().GetMSPID()
	if clientorg == "manufacturerMSP" {
		asset.Owner = "distributorMSP"
		asset.Tanggal_diolah = tanggal_diolah
		asset.Alamat_perusahaan = alamat_perusahaan

	}

	// timestamp, err := ctx.GetStub().GetTxTimestamp()
	dt := time.Now()
	timestampp := dt.Format("01-02-2006 15:04:05")

	if clientorg == "distributorMSP" {
		asset.Owner = "wholesalerMSP"
		asset.JumlahToWholesaler = jumlah
		asset.TimeStamp = timestampp

	}
	if clientorg == "wholesalerMSP" {
		asset.Owner = "retailerMSP"
		asset.JumlahToRetailer = jumlah
		asset.TimeStamp = timestampp

	}
	if clientorg == "retailerMSP" {
		asset.Owner = "consumerMSP"
	}

	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

func (s *SmartContract) LockAsset(ctx contractapi.TransactionContextInterface, id string) error {
	clientorg, err := ctx.GetClientIdentity().GetMSPID()
	if err != nil {
		return err
	}

	assets, err := s.ReadAsset(ctx, id)
	if clientorg == "distributorMSP" {
		assets.Konfirmasi_distributor = true
	}
	if clientorg == "manufacturerMSP" {
		assets.Konfirmasi_manufacturer = true
	}
	if clientorg == "retailerMSP" {
		assets.Konfirmasi_retailer = true
	}
	if clientorg == "wholesalerMSP" {
		assets.Konfirmasi_wholesaler = true
	}
	if err != nil {
		return err
	}
	AssetJSON, err := json.Marshal(assets)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, AssetJSON)
}

// GetAllAssets returns all assets found in world state
func (s *SmartContract) GetAllAssets(ctx contractapi.TransactionContextInterface) ([]*Asset, error) {
	// range query with empty string for startKey and endKey does an
	// open-ended query of all assets in the chaincode namespace.
	resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	var assets []*Asset
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		var asset Asset
		err = json.Unmarshal(queryResponse.Value, &asset)
		if err != nil {
			return nil, err
		}
		assets = append(assets, &asset)
	}

	return assets, nil
}

func main() {
	assetChaincode, err := contractapi.NewChaincode(&SmartContract{})
	if err != nil {
		log.Panicf("Error creating asset-transfer-basic chaincode: %v", err)
	}

	if err := assetChaincode.Start(); err != nil {
		log.Panicf("Error starting asset-transfer-basic chaincode: %v", err)
	}
}
