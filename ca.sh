#!/bin/bash -e

if [ -z "$1" ]; then
    echo "Root name not set!"
    exit 1
fi

if [ ! -d out ]; then
    mkdir out
fi

if [ -f "out/$1.key" ]; then
    echo "Warning: Key ($1.key) already exists. Skipping..."
else
    openssl genrsa -des3 -out "out/$1.key" 4096
fi

if [ -f "out/$1.crt" ]; then
    echo "Error: Certificate ($1.crt) already exists. Aborting."
    exit 1
fi

if [ -f "config/$1.cnf" ]; then
    echo "Generating with configuration '$1.cnf'"
    openssl req -x509 -new -nodes -key "out/$1.key" -config "config/$1.cnf" -days 3560 -out "out/$1.crt"
else
    openssl req -x509 -new -nodes -key "out/$1.key" -days 3560 -out "out/$1.crt"
fi
