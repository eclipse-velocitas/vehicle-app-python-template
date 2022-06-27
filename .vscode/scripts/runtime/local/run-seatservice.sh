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
echo "### Running Seatservice                             ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

SEATSERVICE_VERSION=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .seatservice.version | tr -d '"')
SEATSERVICE_PORT='50051'
SEATSERVICE_GRPC_PORT='52002'
sudo chown $(whoami) $HOME

#Detect host environment (distinguish for Mac M1 processor)
if [[ `uname -m` == 'aarch64' || `uname -m` == 'arm64' ]]; then
  echo "Detected ARM architecture"
  PROCESSOR="aarch64"
  SEATSERVICE_BINARY_NAME="bin_vservice-seat_aarch64_release.tar.gz"
  SEATSERVICE_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/seatservice/$SEATSERVICE_VERSION/$PROCESSOR/target/aarch64/release/install/bin"
else
  echo "Detected x86_64 architecture"
  PROCESSOR="x86_64"
  SEATSERVICE_BINARY_NAME="bin_vservice-seat_x86_64_release.tar.gz"
  SEATSERVICE_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/seatservice/$SEATSERVICE_VERSION/$PROCESSOR/target/x86_64/release/install/bin"
fi

API_URL=https://api.github.com/repos/eclipse/kuksa.val.services

if [[ ! -f "$SEATSERVICE_EXEC_PATH/val_start.sh" ]]
then
  echo "Downloading seatservice:$SEATSERVICE_VERSION"
  SEATSERVICE_ASSET_ID=$(curl $API_URL/releases/tags/$SEATSERVICE_VERSION | jq -r ".assets[] | select(.name == \"$SEATSERVICE_BINARY_NAME\") | .id")
  curl -o $ROOT_DIRECTORY/.vscode/scripts/assets/seatservice/$SEATSERVICE_VERSION/$PROCESSOR/$SEATSERVICE_BINARY_NAME --create-dirs -L -H "Accept: application/octet-stream" "$API_URL/releases/assets/$SEATSERVICE_ASSET_ID"
  tar -xf $ROOT_DIRECTORY/.vscode/scripts/assets/seatservice/$SEATSERVICE_VERSION/$PROCESSOR/$SEATSERVICE_BINARY_NAME -C $ROOT_DIRECTORY/.vscode/scripts/assets/seatservice/$SEATSERVICE_VERSION/$PROCESSOR
fi

export DAPR_GRPC_PORT=$SEATSERVICE_GRPC_PORT
export CAN=cansim
export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker

dapr run \
  --app-id seatservice \
  --app-protocol grpc \
  --app-port $SEATSERVICE_PORT \
  --dapr-grpc-port $SEATSERVICE_GRPC_PORT \
  --components-path $ROOT_DIRECTORY/.dapr/components \
  --config $ROOT_DIRECTORY/.dapr/config.yaml & \
  $SEATSERVICE_EXEC_PATH/val_start.sh
