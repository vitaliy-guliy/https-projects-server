#!/bin/bash

# TODO set yours
DOMAIN=vitaliy-ThinkPad-P50

# CA_CN='My-stamp'
CA_CN='vitaliy-thinkpad-p50'

CA_KEY_FILE='ca.key'
CA_CERT_FILE='ca.crt'

CN_SERVER='My-server'
SERVER_KEY_FILE='domain.key'
SERVER_CERT_REQUEST_FILE='domain.csr'
SERVER_CERT_FILE='domain.crt'

CHAIN_FILE='chain.pem'

# Detect openssl configuration file
OPENSSL_CNF='/etc/pki/tls/openssl.cnf'
if [ ! -f $OPENSSL_CNF ]; then
    OPENSSL_CNF='/etc/ssl/openssl.cnf'
fi

DIR=/tmp/cert
rm -rf $DIR && mkdir $DIR && cd $DIR

# Generate private key for root CA
openssl genrsa -out $CA_KEY_FILE 4096

# Generate root CA certificate and sign it with previously generated key.
openssl req -batch -new -x509 -nodes -key $CA_KEY_FILE -sha256 -subj /CN="${CA_CN}" -days 1024 -reqexts SAN -extensions SAN -config <(cat ${OPENSSL_CNF} <(printf '[SAN]\nbasicConstraints=critical, CA:TRUE\nkeyUsage=keyCertSign, cRLSign, digitalSignature')) -outform PEM -out $CA_CERT_FILE

# Generate server prvate key
openssl genrsa -out $SERVER_KEY_FILE 2048

# Create certificate request for the server endpoint
openssl req --batch -new -sha256 -key $SERVER_KEY_FILE -subj "/CN=${CN_SERVER}" -reqexts SAN -config <(cat $OPENSSL_CNF <(printf "\n[SAN]\nsubjectAltName=DNS:${DOMAIN},DNS:*.${DOMAIN}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth")) -outform PEM -out $SERVER_CERT_REQUEST_FILE

# Create certificate for the server endpoint domain based on given certificate request.
openssl x509 -req -in $SERVER_CERT_REQUEST_FILE -CA $CA_CERT_FILE -CAkey $CA_KEY_FILE -CAcreateserial -days 365 -sha256 -extfile <(printf "subjectAltName=DNS:${DOMAIN},DNS:*.${DOMAIN}\nbasicConstraints=critical, CA:FALSE\nkeyUsage=digitalSignature, keyEncipherment, keyAgreement, dataEncipherment\nextendedKeyUsage=serverAuth") -outform PEM -out $SERVER_CERT_FILE

# Create certificate chain file
cat $SERVER_CERT_FILE $CA_CERT_FILE > $CHAIN_FILE

