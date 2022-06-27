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
echo "### Running FeederCan                               ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

FEEDERCAN_VERSION=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .feedercan.version | tr -d '"')
DATABROKER_GRPC_PORT='52001'
sudo chown $(whoami) $HOME

# Downloading feedercan
FEEDERCAN_SOURCE="feedercan_source"
FEEDERCAN_EXEC_PATH="$ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION"

API_URL=https://api.github.com/repos/eclipse/kuksa.val.feeders

if [[ ! -f "$FEEDERCAN_EXEC_PATH/feeder_can/dbcfeeder.py" ]]
then
  echo "Downloading FEEDERCAN:$FEEDERCAN_VERSION"
  curl --create-dirs -o "$ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/$FEEDERCAN_SOURCE" --location --remote-header-name --remote-name "$API_URL/$FEEDERCAN_VERSION"
  FEEDERCAN_BASE_DIRECTORY=$(tar -tzf $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/$FEEDERCAN_SOURCE | head -1 | cut -f1 -d"/")
  tar -xf $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/$FEEDERCAN_SOURCE -C $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/
  cp -r $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/$FEEDERCAN_BASE_DIRECTORY/feeder_can $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION
  rm -rf $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/$FEEDERCAN_BASE_DIRECTORY
fi
cd $ROOT_DIRECTORY/.vscode/scripts/assets/feedercan/$FEEDERCAN_VERSION/feeder_can
pip3 install -r requirements.txt

export DAPR_GRPC_PORT=$DATABROKER_GRPC_PORT
export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker
export LOG_LEVEL=info,databroker=info,dbcfeeder.broker_client=debug,dbcfeeder=debug
dapr run \
  --app-id feedercan \
  --app-protocol grpc \
  --components-path $ROOT_DIRECTORY/.dapr/components \
  --config $ROOT_DIRECTORY/.dapr/config.yaml & \
  ./dbcfeeder.py
