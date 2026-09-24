#!/usr/bin/env bash

#
# Required Notice: Copyright Dany Reyna (https://danyreyna.com)
#

# uncomment to debug
# set -x

set -Eeuo pipefail
IFS=$'\n\t'
trap_err() {
  exit_status_before_echo=${?}
  echo >&2 "Error at $(caller): ${BASH_COMMAND}"
  exit ${exit_status_before_echo}
}
trap trap_err ERR

source_branch="${1}"
destination_branch="${2}"

git switch "${destination_branch}"

commit_hashes=$(git log "${destination_branch}".."${source_branch}" --format="%h" --reverse)

for commit_hash in ${commit_hashes}; do
  git cherry-pick -n "${commit_hash}"
  commit_message=$(git log --format="%B" -n 1 "${commit_hash}")
  git commit -m "${commit_message}"
done
