#!/bin/bash
# Copyright (c) 2022 Robert Bosch GmbH and Microsoft Corporation
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
echo "### Running VehicleDataBroker CLI                   ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

# Get Data from AppManifest.json and save to ENV
UTILS_DIRECTORY="$ROOT_DIRECTORY/.vscode/scripts/runtime/utils"
source $UTILS_DIRECTORY/get-appmanifest-data.sh

sudo chown $(whoami) $HOME

# Needed because of how the databroker release is tagged
DATABROKER_ASSET_FOLDER="$ROOT_DIRECTORY/.vscode/scripts/assets/databroker/$DATABROKER_TAG"
#Detect host environment (distinguish for Mac M1 processor)
if [[ `uname -m` == 'aarch64' || `uname -m` == 'arm64' ]]; then
    echo "Detected ARM architecture"
    PROCESSOR="aarch64"
    DATABROKER_BINARY_NAME="databroker_aarch64.tar.gz"
    DATABROKER_EXEC_PATH="$DATABROKER_ASSET_FOLDER/$PROCESSOR/target/aarch64-unknown-linux-gnu/release"
else
    echo "Detected x86_64 architecture"
    PROCESSOR="x86_64"
    DATABROKER_BINARY_NAME='databroker_x86_64.tar.gz'
    DATABROKER_EXEC_PATH="$DATABROKER_ASSET_FOLDER/$PROCESSOR/target/release"
fi

if [[ ! -f "$DATABROKER_EXEC_PATH/databroker" ]]
then
    DOWNLOAD_URL=https://github.com/boschglobal/kuksa.val/releases/download
    echo "Downloading databroker:$DATABROKER_TAG"
    curl -o $DATABROKER_ASSET_FOLDER/$PROCESSOR/$DATABROKER_BINARY_NAME --create-dirs -L -H "Accept: application/octet-stream" "$DOWNLOAD_URL/$DATABROKER_TAG/$DATABROKER_BINARY_NAME"
    tar -xf $DATABROKER_ASSET_FOLDER/$PROCESSOR/$DATABROKER_BINARY_NAME -C $DATABROKER_ASSET_FOLDER/$PROCESSOR
fi

$DATABROKER_EXEC_PATH/databroker-cli
