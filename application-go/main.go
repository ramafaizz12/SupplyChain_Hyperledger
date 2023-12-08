/*
Copyright 2020 IBM All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	configdb "fabric_network/config"
	"fabric_network/controller"
	"fabric_network/gatewayy"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/hyperledger/fabric-sdk-go/pkg/gateway"
	_ "github.com/lib/pq"
)

func main() {
	db, err := configdb.ConnectDB()
	if err != nil {
		panic(err)
	}
	gin.SetMode(gin.ReleaseMode)
	router := gin.Default()

	AuthController := controller.AuthController{
		Db: db,
	}
	err = os.Setenv("DISCOVERY_AS_LOCALHOST", "true")
	if err != nil {
		log.Fatalf("Error setting DISCOVERY_AS_LOCALHOST environemnt variable: %v", err)
	}

	// discovery := os.Getenv("DISCOVERY_AS_LOCALHOST")
	// if discovery == "" {
	// 	discovery = "false"
	// }
	// contract := network.GetContract("scberas")
	fabricHandler := &gatewayy.Gatewayy{
		Db: db,
	}

	router.GET("/PING", func(ctx *gin.Context) {
		ctx.JSON(http.StatusOK, map[string]interface{}{
			"message": "ok",
		})
	})
	router.POST("/register", AuthController.Register)
	router.POST("/ReadAsset", AuthController.CheckAuth(), fabricHandler.ConnectToGateway, fabricHandler.ReadAsset)
	router.POST("/login", AuthController.Login)
	router.GET("/coba", AuthController.CheckAuth())
	router.POST("/AssetTransfer", AuthController.CheckAuth(), fabricHandler.ConnectToGateway, fabricHandler.AssetTransfer)
	router.POST("/CreateAsset", AuthController.CheckAuth(), fabricHandler.ConnectToGateway, fabricHandler.CreateAsset)
	router.GET("/cobaprofile", AuthController.CheckAuth(), AuthController.Profile)

	router.POST("/LockAsset", AuthController.CheckAuth(), fabricHandler.ConnectToGateway, fabricHandler.LockAsset)
	port := os.Getenv("PORT")
	if port == "" {
		port = "4444"
	}
	if err := router.Run("0.0.0.0:" + port); err != nil {
		log.Panicf("error: %s", err)
	}

}

func UpdateAsset(contract *gateway.Contract, assets string, tanggal_diolah string, alamat_perusahaan string) error {
	log.Println("============ Update Asset ============")
	result, err := contract.SubmitTransaction("TransferAsset", assets, tanggal_diolah, alamat_perusahaan)

	log.Println(string(result))
	return err
}
func CreateAsset(contract *gateway.Contract) error {
	log.Println("--> Submit Transaction: CreateAsset, creates new asset with ID, color, owner, size, and appraisedValue arguments")
	result, err := contract.SubmitTransaction("CreateAssets", "asset17", "lele_bakarrrr", "farhann", "abduldaengsiruaa", "11-12-2001")

	if err != nil {
		log.Fatalf("Failed to Submit transaction: %v", err)
	}
	log.Println(string(result))
	return err
}
