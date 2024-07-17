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
	Owner                   string `json:"owner"`
	Alamat                  string `json:"alamat"`
	Lama_panen              string `json:"lama_panen"`
	Tanggal_panen           string `json:"tanggal_panen"`
	Konfirmasi_manufacturer bool   `json:"konfirmasi_manufacturer"`
	Konfirmasi_distributor  bool   `json:"konfirmasi_distributor"`
	Konfirmasi_wholesaler   bool   `json:"konfirmasi_wholesaler"`
	Nohp                    string `json:"no_hp"`
	Lama_Pengeringan        string `json:"lama_pengeringan"`
	Kadar_Air               string `json:"kadar_air"`
	Butir_Gabah             string `json:"butir_gabah"`
	Benda_lain              string `json:"benda_lain"`
	Butir_Patah             string `json:"butir_patah"`
	Beras_Kepala            string `json:"beras_kepala"`
	Derajat_Sosoh           string `json:"derajat_sosoh"`
	Lama_penyimpanan        string `json:"lama_penyimpanan"`
	JumlahToWholesaler      string `json:"jumlahToWholesaler"`
	TimeStamp               string `json:"timestamp"`
}

// Fungsi CreateAsset untuk membuat asset dengan informasi awal pada aktor petani
func (s *SmartContract) CreateAssets(ctx contractapi.TransactionContextInterface, id string, nama_petani string, alamat string, tanggal_panen string, nohp string, lama_panen string) error {
	exists, err := s.AssetExists(ctx, id)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("ID %s sudah ada", id)
	}

	clientorg, err := ctx.GetClientIdentity().GetMSPID()
	if clientorg != "farmerMSP" {
		return fmt.Errorf("maaf anda bukan farmer")
	}
	if err != nil {
		return err
	}

	asset := Asset{
		ID:            id,
		Nama_petani:   nama_petani,
		Owner:         "manufacturerMSP",
		Alamat:        alamat,
		Lama_panen:    lama_panen,
		Nohp:          nohp,
		Tanggal_panen: tanggal_panen,
	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

// Membaca Detail Asset berdasarkan ID
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
		asset = Asset{}
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

// Fungsi untuk mentransfer detail asset ke distributor
func (s *SmartContract) TransferAssetToDistributor(ctx contractapi.TransactionContextInterface, id string, jumlah string, lama_pengeringan string, lama_penyimpanan string, kadar_air string, derajat_sosoh string, beras_kepala string, butir_patah string, butir_gabah string, benda_lain string) error {
	asset, err := s.ReadAsset(ctx, id)
	if err != nil {
		return err
	}

	clientorg, _ := ctx.GetClientIdentity().GetMSPID()
	if clientorg == "manufacturerMSP" {
		asset.Lama_Pengeringan = lama_pengeringan
		asset.Lama_penyimpanan = lama_penyimpanan
		asset.Kadar_Air = kadar_air
		asset.Derajat_Sosoh = derajat_sosoh
		asset.Beras_Kepala = beras_kepala
		asset.Butir_Patah = butir_patah
		asset.Butir_Gabah = butir_gabah
		asset.Benda_lain = benda_lain
		asset.Owner = "distributorMSP"

	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

// Fungsi untuk mentransfer detail asset ke pedagang besar
func (s *SmartContract) TransferAssetToWholesaler(ctx contractapi.TransactionContextInterface, id string, jumlah string) error {
	asset, err := s.ReadAsset(ctx, id)
	if err != nil {
		return err
	}

	dt := time.Now()
	timestampp := dt.Format("01-02-2006 15:04:05")

	clientorg, _ := ctx.GetClientIdentity().GetMSPID()
	if clientorg == "distributorMSP" {
		asset.Owner = "wholesalerMSP"
		asset.JumlahToWholesaler = jumlah
		asset.TimeStamp = timestampp

	}
	assetJSON, err := json.Marshal(asset)
	if err != nil {
		return err
	}

	return ctx.GetStub().PutState(id, assetJSON)
}

// Fungsi untuk mengunci asset pada aktor
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

	if clientorg == "wholesalerMSP" {
		assets.Konfirmasi_wholesaler = true
		dt := time.Now()
		timestampp := dt.Format("01-02-2006 15:04:05")
		assets.TimeStamp = timestampp
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
