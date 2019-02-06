#!/bin/bash

ROOT_CA_FILENAME=ca
INTERMEDIATE_CA_FILENAME=intermediate

echo "What is the filename of this certificate:"
read CERT_FILENAME

echo "What is the duration (in Years)":
read CA_DURATION_TEXT

echo "Which mode do you want to use? 'usr_cert' (for clients) or 'server_cert' (for servers):"
read CERT_MODE

DAYS_IN_YEAR="365"
CA_DURATION=$(($CA_DURATION_TEXT * $DAYS_IN_YEAR))

# =================================================
echo "Generating $CERT_FILENAME private key"
openssl genrsa -aes256 -out "intermediate/private/$CERT_FILENAME.key.pem" 4096
chmod 400 "intermediate/private/$CERT_FILENAME.key.pem"

echo "Generating $CERT_FILENAME"
openssl req -config intermediate/openssl.cnf -new -sha256 \
  -key "intermediate/private/$CERT_FILENAME.key.pem" \
  -out "intermediate/csr/$CERT_FILENAME.csr.pem"
# =================================================

echo "Signing $CERT_FILENAME using Intermediate CA"
openssl ca -config intermediate/openssl.cnf \
      -extensions $CERT_MODE -days $CA_DURATION -notext -md sha256 \
      -in "intermediate/csr/$CERT_FILENAME.csr.pem" \
      -out "intermediate/certs/$CERT_FILENAME.cert.pem"

chmod 444 "intermediate/certs/$CERT_FILENAME.cert.pem"
# =================================================

cat "intermediate/certs/$CERT_FILENAME.cert.pem" "intermediate/certs/$INTERMEDIATE_CA_FILENAME.ca-chain.cert.pem" > "intermediate/certs/$CERT_FILENAME.ca-chain.cert.pem"
chmod 444 "intermediate/certs/$CERT_FILENAME.ca-chain.cert.pem"

# =================================================

echo "Generating PFX File"
openssl pkcs12 -export -out "intermediate/pfx/$CERT_FILENAME.pfx" -inkey "intermediate/private/$CERT_FILENAME.key.pem" -in "intermediate/certs/$CERT_FILENAME.ca-chain.cert.pem"
chmod 444 "intermediate/pfx/$CERT_FILENAME.pfx"

echo ""
echo ""
echo ""
echo "Validating Certificate"
openssl verify -CAfile "intermediate/certs/$INTERMEDIATE_CA_FILENAME.ca-chain.cert.pem" "intermediate/certs/$CERT_FILENAME.cert.pem"
echo ""
echo "To View Certificate use:"
echo "openssl x509 -noout -text -in \"intermediate/certs/$CERT_FILENAME.cert.pem\""
