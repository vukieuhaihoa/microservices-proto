#!/bin/bash

SERVICE_NAME=$1
SERVICE_VERSION=$2
RELEASE_VERSION=$3

# When a query returns a non-zero status, the -e flag stops the script.
set -e

echo "Lint and generate proto...."
case $SERVICE_NAME in
  "order")
    # lint and gen
    make buf-lint-order
    make buf-gen-order
    ;;
 "payment")
    # lint and gen
    make buf-lint-payment
    make buf-gen-payment
    ;;
 "shipping")
    # lint and gen
    make buf-lint-shipping
    make buf-gen-shipping
    ;;
 *)
    echo "error: Invalid service name $SERVICE_NAME"
    exit 1
    ;;
esac
echo "Lint and generate proto done!"

# go mod init for 
cd gen/go/${SERVICE_NAME}
go mod init \
  github.com/vukieuhaihoa/microservices-proto/go/gen/${SERVICE_NAME}
go mod tidy

cd ../../../
pwd

