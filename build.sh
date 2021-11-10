#!/bin/bash

mkdir -p bin
crystal build src/gorilla.cr --release --stats -o bin/gorilla

echo ""
echo "Check out: https://github.com/krishpranav/gorilla"