#!/bin/bash
#
# This script to generate to Golang code from proto file use buf

SERVICE_NAME=$1
SERVICE_VERSION=$2
RELEASE_VERSION=$3

# When a query returns a non-zero status, the -e flag stops the script.
set -euo pipefail

#######################################
# Go to path
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
# Example:
# goto_dir ./gg/hh
#######################################
function goto_dir() {
   path=$1
   pushd $path >/dev/null
}

#######################################
# Go to previous path
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
# Example:
# goto_dir ./gg/hh
#######################################
function leave_dir() {
   popd >/dev/null
}

function init_go_mod_and_tidy() {
   # go to service folder
   echo "Go to folder ${SERVICE_NAME} and download dependencies"
   goto_dir ./gen/go/${SERVICE_NAME}

   if [ -e go.mod ]; then
      echo "go.mod file is already!"
   else
      go mod init \
         github.com/vukieuhaihoa/microservices-proto/gen/go/${SERVICE_NAME}
   fi
   # download dependencies
   go mod tidy
   echo "Install dependencies success!"
   leave_dir
}

# Generate code from *.proto file
function buf_gen() {
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

buf_gen

init_go_mod_and_tidy
