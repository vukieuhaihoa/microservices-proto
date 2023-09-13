#!/bin/bash

SERVICE_NAME=$1
SERVICE_VERSION=$2
RELEASE_VERSION=$3

# When a query returns a non-zero status, the -e flag stops the script.
set -e

# Helper func to go one path
# Usage: gotoDir ./proto/shipping/v1
function gotoDir() {
   path=$1
   pushd $path >/dev/null
}

# Helper func to go to the previous path
# Usage: leaveDir
function leaveDir() {
   popd >/dev/null
}

function initGoModAndTidy() {
   # go to service folder
   echo "Go to folder ${SERVICE_NAME} and download dependencies"
   gotoDir ./gen/go/${SERVICE_NAME}

   if [ -e go.mod ]; then
      echo "go.mod file is already!"
   else
      go mod init \
         github.com/vukieuhaihoa/microservices-proto/gen/go/${SERVICE_NAME}
   fi
   # download dependencies
   go mod tidy
   echo "Install dependencies sucess!"
   leaveDir
}

# Generate code from *.proto file
function bufGen() {
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
}

bufGen

initGoModAndTidy

pwd
