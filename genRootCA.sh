#!/bin/bash

ROOT_CA_FILENAME=ca

echo "What is the duration (in Years)":
read CA_DURATION_TEXT

DAYS_IN_YEAR="365"
CA_DURATION=$(($CA_DURATION_TEXT * $DAYS_IN_YEAR))

echo "Generating $ROOT_CA_FILENAME private key"
openssl genrsa -aes256 -out "private/$ROOT_CA_FILENAME.key.pem" 4096
chmod 400 "private/$ROOT_CA_FILENAME.key.pem"

echo "Generating $ROOT_CA_FILENAME"
openssl req -config openssl.cnf \
    -key "private/$ROOT_CA_FILENAME.key.pem" \
    -new -x509 -days $CA_DURATION -sha256 -extensions v3_ca \
    -out "certs/$ROOT_CA_FILENAME.cert.pem"
chmod 444 "certs/$ROOT_CA_FILENAME.cert.pem"

echo ""
echo ""
echo ""
echo "SUCCESS. To verify Root Certificate use:"
echo "openssl x509 -noout -text -in \"certs/$ROOT_CA_FILENAME.cert.pem\""
