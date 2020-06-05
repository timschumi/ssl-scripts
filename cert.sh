#!/bin/bash -e

if [ -z "$1" ]; then
    echo "CA name not set!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "Cert name not set!"
    exit 1
fi

if [ ! -d out ]; then
    mkdir out
fi

if [ ! -f "out/$1.key" -o ! -f "out/$1.crt" ]; then
    echo "CA key does not exist"
    exit 1
fi

if [ -f "out/$2.key" ]; then
    echo "Warning: Key ($2.key) already exists. Skipping..."
else
    openssl genrsa -out "out/$2.key" 2048
fi

if [ -f "$out/2.crt" -o -f "out/$2.csr" ]; then
    echo "Error: Certificate ($2.crt) or signing request already exists. Aborting."
    exit 1
fi

if [ -f "config/$2.cnf" ]; then
    echo "Creating certificate with config: '$2.cnf'"
    openssl req -new -key "out/$2.key" -config "config/$2.cnf" -out "out/$2.csr"
    openssl x509 -req -in "out/$2.csr" -CA "out/$1.crt" -CAkey "out/$1.key" -CAcreateserial -out "out/$2.crt" -days 365 -extfile "config/$2.cnf" -extensions v3_req
else
    openssl req -new -key "out/$2.key" -out "out/$2.csr"
    openssl x509 -req -in "out/$2.csr" -CA "out/$1.crt" -CAkey "out/$1.key" -CAcreateserial -out "out/$2.crt" -days 365
fi

