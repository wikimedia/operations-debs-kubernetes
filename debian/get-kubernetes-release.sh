#!/bin/bash

DEB_VERSION_UPSTREAM=$1

TAR_NAME=kubernetes-server-linux-amd64.tar.gz
CHANGELOG_URL="https://raw.githubusercontent.com/kubernetes/kubernetes/master/CHANGELOG/CHANGELOG-$(echo ${DEB_VERSION_UPSTREAM} | cut -d. -f1,2).md"

set +e
curl -sL "${CHANGELOG_URL}" | grep "${DEB_VERSION_UPSTREAM}/${TAR_NAME}" > CHANGELOG.md
if [ ${PIPESTATUS[0]} -eq 7 ]; then
    >&2 echo "curl failed to connect to host"
    >&2 echo "Do you need to set http(s)_proxy variables?"
    exit 7
fi
set -e

SHA512_SUM=$(sed -nE 's|.*([0-9a-f]{128}).*|\1|p' < CHANGELOG.md)
TAR_URL=$(sed -nE 's|.*\((https.+)\).*|\1|p' < CHANGELOG.md)

test -f "${TAR_NAME}" || curl -sL "${TAR_URL}" > "${TAR_NAME}"
echo -n "$cat $SHA512_SUM  ${TAR_NAME}" | sha512sum --status -c
