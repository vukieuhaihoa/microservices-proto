#!/bin/bash
#
# This script to gen next tag version of service

# Exit when error occur
set -e

SERVICE=$1
VERSION=$2
#######################################
# Get the latest tag version of service.
# Globals:
#   None
# Arguments:
#   $1: regex to get latest version
# Outputs:
#   String of latest tag version
#   Example: gen/go/order/v1.0.0
#######################################
function get_latest_tag_version() {
  regex=$1
  arr_tags=($(git tag -l | grep -E $regex | cut -d ' ' -f 1))
  if [[ ${#arr_tags[@]} == 0 ]]; then
    echo "gen/go/${SERVICE}/v0.0.0"
    exit 0
  fi
  latest_tag=${arr_tags[${#arr_tags[@]} - 1]}
  # return the latest tag
  echo ${latest_tag}
}

#######################################
## Create next tag version.
## Globals:
##   SERVICE
## Arguments:
##   None
## Outputs:
##   String of latest tag version
##   Example: gen/go/order/v1.0.0 if service is "order"
########################################
function creat_next_tag_version() {
  regex="^gen/go/$SERVICE/v[0-9]+.[0-9]+.[0-9]+"
  latest_tag=$(get_latest_tag_version $regex) # look like: gen/go/order/v1.0.1
  str=$(echo $latest_tag | cut -d / -f 4)     # look like: v1.0.1
  CURRENT_VERSION="${str:1}"                  # look like: 1.0.1
  # replace . with space so can split into an array
  CURRENT_VERSION_PARTS=(${CURRENT_VERSION//./ })

  # get number parts
  VNUM1=${CURRENT_VERSION_PARTS[0]} # major part
  VNUM2=${CURRENT_VERSION_PARTS[1]} # minor part
  VNUM3=${CURRENT_VERSION_PARTS[2]} # patch part

  case "${VERSION}" in
  "major")
    VNUM1=$((VNUM1 + 1))
    VNUM2=0
    VNUM3=0
    ;;
  "minor")
    VNUM2=$((VNUM2 + 1))
    VNUM3=0
    ;;
  "patch")
    VNUM3=$((VNUM3 + 1))
    ;;
  *)
    echo "Invalid version"
    exit 1
    ;;
  esac
  new_tag="gen/go/$SERVICE/v$VNUM1.$VNUM2.$VNUM3"
  echo $new_tag
}

# This is format of one tag for service "order" git tag -fa gen/go/order/v0.0.0

# Entry point
new_tag=$(creat_next_tag_version)
echo $new_tag
#regex="^gen/go/$SERVICE/v[0-9]+.[0-9]+.[0-9]+"
#get_latest_tag_version $regex
