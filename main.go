package main

import (
	"crypto/x509"
	"database/sql"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"time"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	username := os.Getenv("DATABASE_USER")
	password := os.Getenv("DATABASE_PASSWORD")
	host := os.Getenv("DATABASE_HOST")
	port := os.Getenv("DATABASE_PORT")

	connectionString := fmt.Sprintf("%s:%s@tcp(%s:%s)/ejbca?charset=utf8", username, password, host, port)

	log.Printf("Attempting to open connection to EJBCA database at %s:%s", host, port)

	db, err := sql.Open("mysql", connectionString)
	if err != nil {
		log.Fatal(err)
	}

	db.SetConnMaxLifetime(time.Minute * 3)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	query := `
SELECT 
    fingerprint,
    base64Cert
FROM
    Base64CertData;
`

	log.Printf("Running the following query:\n%s", query)

	rows, err := db.Query(query)
	if err != nil {
		log.Fatal(err)
	}

	defer func(rows *sql.Rows) {
		err = rows.Close()
		if err != nil {
			log.Fatal(err)
		}
	}(rows)

	var certPem []byte

	cn := "ManagementCA"

	for rows.Next() {
		var (
			fingerprint string
			base64Cert  string
		)

		if err = rows.Scan(&fingerprint, &base64Cert); err != nil {
			log.Fatal(err)
		}

		certDer, err := base64.StdEncoding.DecodeString(base64Cert)
		if err != nil {
			log.Fatal(err)
		}

		certificate, err := x509.ParseCertificate(certDer)
		if err != nil {
			log.Fatal(err)
		}

		if cn == certificate.Subject.CommonName {
			log.Printf("Found %s certificate", certificate.Subject.CommonName)
			certPem = pem.EncodeToMemory(&pem.Block{Bytes: certDer, Type: "CERTIFICATE"})
		}
	}

	err = db.Close()
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("Closed connection to database")

	certDir := fmt.Sprintf("%s%s.pem", os.Getenv("CERTIFICATE_DIRECTORY"), cn)

	err = ioutil.WriteFile(certDir, certPem, 644)
	if err != nil {
		log.Fatal(err)
	}

	log.Printf("Wrote %s certificate to %s", cn, certDir)
}
