#!/bin/bash
#
# This script to auto tag

# Exit when error occur
set -e

SERVICE=""
VERSION=""

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
chmod +x ./tag-gen.sh
ready_to_run
# fetch all tags from repo
git fetch --all --tags
newest_tag=$(./tag-gen.sh $SERVICE $VERSION)

# git tag
git checkout main
git tag $newest_tag
git push origin $newest_tag
