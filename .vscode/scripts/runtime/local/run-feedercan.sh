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

# Get Data from AppManifest.json and save to ENV
UTILS_DIRECTORY="$ROOT_DIRECTORY/.vscode/scripts/runtime/utils"
source $UTILS_DIRECTORY/get-appmanifest-data.sh

### Override default files for feedercan
CONFIG_DIR="$ROOT_DIRECTORY/deploy/runtime/k3d/volume"

export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker
export DAPR_GRPC_PORT=52001
export LOG_LEVEL=info,databroker=info,dbcfeeder.broker_client=info,dbcfeeder=info
export USECASE=databroker

export CANDUMP_FILE="/data/candumpDefault.log"
export DBC_FILE="/data/dbcfileDefault.dbc"
export MAPPING_FILE="/data/mappingDefault.yml"

RUNNING_CONTAINER=$(docker ps | grep "$FEEDERCAN_IMAGE" | awk '{ print $1 }')

if [ -n "$RUNNING_CONTAINER" ];
then
    docker container stop $RUNNING_CONTAINER
fi

docker run \
    -v ${CONFIG_DIR}:/data \
    -e VEHICLEDATABROKER_DAPR_APP_ID \
    -e DAPR_GRPC_PORT \
    -e LOG_LEVEL \
    -e USECASE \
    -e CANDUMP_FILE \
    -e DBC_FILE \
    -e MAPPING_FILE \
    --network host \
    $FEEDERCAN_IMAGE:$FEEDERCAN_TAG &

dapr run \
    --app-id feedercan \
    --app-protocol grpc \
    --components-path $ROOT_DIRECTORY/.dapr/components \
    --config $ROOT_DIRECTORY/.dapr/config.yaml && fg
