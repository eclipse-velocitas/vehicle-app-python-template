#!/bin/bash
# This file is maintained by velocitas CLI, do not modify manually. Change settings in .velocitas.json
# Copyright (c) 2023-2024 Contributors to the Eclipse Foundation
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

echo "#######################################################"
echo "### Auto-upgrade CLI                                ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../.." )
DESIRED_VERSION=$(cat $ROOT_DIRECTORY/.velocitas.json | jq .cliVersion | tr -d '"')

# Get installed CLI version
INSTALLED_VERSION=v$(velocitas --version | sed -E 's/velocitas-cli\/(\w+.\w+.\w+).*/\1/')

if [ "$DESIRED_VERSION" = "$INSTALLED_VERSION" ]; then
  echo "> Already up to date!"
  exit 0
else
  echo "> Checking upgrade to $DESIRED_VERSION"
fi

AUTHORIZATION_HEADER=""
if [ "${GITHUB_API_TOKEN}" != "" ]; then
  AUTHORIZATION_HEADER="-H \"Authorization: Bearer ${GITHUB_API_TOKEN}\""
fi

if [ "$DESIRED_VERSION" = "latest" ]; then
  CLI_RELEASES_URL=https://api.github.com/repos/eclipse-velocitas/cli/releases/latest
else
  CLI_RELEASES_URL=https://api.github.com/repos/eclipse-velocitas/cli/releases/tags/${DESIRED_VERSION}
fi

CLI_RELEASES=$(curl -s -L \
-H "Accept: application/vnd.github+json" \
-H "X-GitHub-Api-Version: 2022-11-28" \
${AUTHORIZATION_HEADER} \
${CLI_RELEASES_URL})

res=$?
if test "$res" != "0"; then
   echo "the curl command failed with exit code: $res"
   exit 0
fi

DESIRED_VERSION_TAG=$(echo ${CLI_RELEASES} | jq -r .name)

if [ "$DESIRED_VERSION_TAG" = "null" ] || [ "$DESIRED_VERSION_TAG" = "" ]; then
  echo "> Can't find desired Velocitas CLI version: $DESIRED_VERSION. Skipping Auto-Upgrade."
  exit 0
fi

if [ "$DESIRED_VERSION_TAG" != "$INSTALLED_VERSION" ]; then
  echo "> Upgrading CLI..."
  if [[ $(arch) == "aarch64" ]]; then
    CLI_ASSET_NAME=velocitas-linux-arm64
  else
    CLI_ASSET_NAME=velocitas-linux-x64
  fi
  CLI_INSTALL_PATH=/usr/bin/velocitas
  CLI_DOWNLOAD_URL="https://github.com/eclipse-velocitas/cli/releases/download/${DESIRED_VERSION_TAG}/${CLI_ASSET_NAME}"

  echo "> Downloading Velocitas CLI from ${CLI_DOWNLOAD_URL}"
  sudo curl -s -L ${CLI_DOWNLOAD_URL} -o "${CLI_INSTALL_PATH}"
  sudo chmod +x "${CLI_INSTALL_PATH}"
else
  echo "> Up to date!"
fi

echo "> Using CLI: $(velocitas --version)"
