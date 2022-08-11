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

# Get Data from AppManifest.json and save to ENV
UTILS_DIRECTORY=$(dirname `cd ..; dirname "$0"`)/utils
source $UTILS_DIRECTORY/get-appmanifest-data.sh

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

SEATSERVICE_PORT='50051'

export SEATSERVICE_GRPC_PORT='52002'
export CAN=cansim
export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker

RUNNING_CONTAINER=$(docker ps | grep "$SEATSERVICE_IMAGE" | awk '{ print $1 }')

if [ -n "$RUNNING_CONTAINER" ];
then
    docker container stop $RUNNING_CONTAINER
fi

docker run \
    -p $SEATSERVICE_PORT:$SEATSERVICE_PORT \
    -p $SEATSERVICE_GRPC_PORT:$SEATSERVICE_GRPC_PORT \
    -e VEHICLEDATABROKER_DAPR_APP_ID \
    -e CAN \
    -e DAPR_GRPC_PORT \
    --network host \
    $SEATSERVICE_IMAGE:$SEATSERVICE_TAG &

dapr run \
    --app-id seatservice \
    --app-protocol grpc \
    --app-port $SEATSERVICE_PORT \
    --dapr-grpc-port $SEATSERVICE_GRPC_PORT \
    --components-path $ROOT_DIRECTORY/.dapr/components \
    --config $ROOT_DIRECTORY/.dapr/config.yaml && fg

