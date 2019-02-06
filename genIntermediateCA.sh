#!/bin/bash

ROOT_CA_FILENAME=ca
CA_FILENAME=intermediate

echo "What is the duration (in Years)":
read CA_DURATION_TEXT

DAYS_IN_YEAR="365"
CA_DURATION=$(($CA_DURATION_TEXT * $DAYS_IN_YEAR))

# =================================================
echo "Generating $CA_FILENAME private key"
openssl genrsa -aes256 -out "intermediate/private/$CA_FILENAME.key.pem" 4096
chmod 400 "intermediate/private/$CA_FILENAME.key.pem"

# ==================================================
echo "Generating $CA_FILENAME"
openssl req -config intermediate/openssl.cnf -new -sha256 \
  -key "intermediate/private/$CA_FILENAME.key.pem" \
  -out "intermediate/csr/$CA_FILENAME.csr.pem"

echo "Signing $CA_FILENAME using Root CA"
openssl ca -config openssl.cnf -extensions v3_intermediate_ca \
  -days $CA_DURATION -notext -md sha256 \
  -in "intermediate/csr/$CA_FILENAME.csr.pem" \
  -out "intermediate/certs/$CA_FILENAME.cert.pem"

chmod 444 "intermediate/certs/$CA_FILENAME.cert.pem"

# ==================================================
cat "intermediate/certs/$CA_FILENAME.cert.pem" "certs/$ROOT_CA_FILENAME.cert.pem" > "intermediate/certs/$CA_FILENAME.ca-chain.cert.pem"
chmod 444 "intermediate/certs/$CA_FILENAME.ca-chain.cert.pem"

echo ""
echo ""
echo ""
echo "Validating Certificate"
openssl verify -CAfile "certs/$ROOT_CA_FILENAME.cert.pem" "intermediate/certs/$CA_FILENAME.cert.pem"
echo ""
echo "To View Intermediate Certificate use:"
echo "openssl x509 -noout -text -in \"intermediate/certs/$CA_FILENAME.cert.pem\""
