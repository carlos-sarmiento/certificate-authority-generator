#!/bin/bash

# Source: OpenSSL Certificate Authority: https://jamielinux.com/docs/openssl-certificate-authority/index.html

# Prepare the root directory
echo "Preparing root directory..."

mkdir -p certs crl newcerts private
chmod 700 private
touch index.txt

# ROOT

ROOT_PATH=$(pwd)


# Prepare the root configuration file
echo "Preparing root configuration file..."
cp openssl.cnf.root.template openssl.cnf
sed -i "s|{SCRIPT_ROOT}|$ROOT_PATH|g" openssl.cnf

# Prepare the intermediate directory
echo "Preparing intermediate directory..."
mkdir -p intermediate

cd intermediate
mkdir -p certs crl csr newcerts private pfx
chmod 700 private
touch index.txt

# Prepare the intermediate configuration file
echo "Preparing intermediate configuration file..."
cp ../openssl.cnf.intermediate.template openssl.cnf
sed -i "s|{SCRIPT_ROOT}|$ROOT_PATH|g" openssl.cnf

cd $ROOT_PATH