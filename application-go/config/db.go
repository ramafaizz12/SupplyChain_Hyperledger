package config

import (
	"database/sql"
	"fmt"
)

func ConnectDB() (*sql.DB, error) {
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		"containers-us-west-171.railway.app",
		"7233",
		"postgres",
		"vAOk0d91UwVVQHu8PEdi",
		"railway",
	)

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}
	return db, nil
}
