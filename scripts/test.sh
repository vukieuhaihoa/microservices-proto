#!/bin/bash

# Exit on error
set -euo pipefail

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

gotoDir ./proto/shipping/v1
echo xamlol >test

sleep 5

if [ -e test ]; then
  echo "Exist file test!!!"
else
  echo "Not exist file test!~!!"
fi

rm -rf test
leaveDir
