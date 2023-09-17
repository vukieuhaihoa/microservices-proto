#!/bin/bash
#
# This script to gen next tag version of service

# Exit when error occur
set -e

SERVICE=""
VERSION=""

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

#######################################
# Print help menu.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   None
#######################################
function help() {
  echo "Script to generate next version tag of service:"
  echo "flags:"
  echo "-h: help menu."
  echo "-s: name of service."
  echo "  Example, for \"order\" service: ./tag.sh -s order"
  echo "-v: name of version[major, minor, patch]: \"major\" or \"minor\"."
  echo "  Example, for \"major\" version: ./tag.sh -v major"
}

# g: have value to pass
# h no need value
while getopts "s:v:h" flag; do
  case "${flag}" in
  h)
    help
    exit 0
    ;;
  s) SERVICE="${OPTARG}" ;;
  v) VERSION="${OPTARG}" ;;
  *)
    echo "script usage: $(basename $BASH_SOURCE) [-s order] [-v major] [-h]" >&2
    exit 1
    ;;
  esac
done
shift "$(($OPTIND - 1))"

function ready_to_run() {
  if [[ -z $SERVICE ]]; then
    echo "You need to pass flag -s to command"
    exit 1
  fi

  if [[ "${SERVICE}" != "order" && "${SERVICE}" != "shipping" && "${SERVICE}" != "payment" ]]; then
    echo "Invalid service!"
    exit 1
  fi

  if [[ -z $VERSION ]]; then
    echo "You need to pass flag -v to command"
    exit 1
  fi
}

#################################
# Entry point
#################################
ready_to_run
# fetch all tags from repo
git fetch --all --tags

# git tag
git checkout develop

newest_tag=$(creat_next_tag_version)
echo $newest_tag

git tag $newest_tag
git push origin $newest_tag
#regex="^gen/go/$SERVICE/v[0-9]+.[0-9]+.[0-9]+"
#get_latest_tag_version $regex
