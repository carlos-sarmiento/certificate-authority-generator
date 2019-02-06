#!/bin/bash

# We use SUDO here to override the write permissions
# This script should only be used during development to clear all artifacts and retest

sudo rm -r certs
sudo rm -r crl
sudo rm -r intermediate
sudo rm -r newcerts
sudo rm -r private
sudo rm index.txt*
sudo rm openssl.cnf
sudo rm serial*
