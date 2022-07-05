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

if ! helm status vehicleappruntime &> /dev/null
then
    ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

    VEHICLEDATABROKER_TAG=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .databrokerimage.version | tr -d '"')
    SEATSERVICE_TAG=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .seatservice.version | tr -d '"')
    FEEDERCAN_TAG=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .feedercan.version | tr -d '"')

    docker pull ghcr.io/eclipse/kuksa.val/databroker:$VEHICLEDATABROKER_TAG
    docker tag ghcr.io/eclipse/kuksa.val/databroker:$VEHICLEDATABROKER_TAG localhost:12345/vehicledatabroker:$VEHICLEDATABROKER_TAG
    docker push localhost:12345/vehicledatabroker:$VEHICLEDATABROKER_TAG

    docker pull ghcr.io/eclipse/kuksa.val.services/seat_service:$SEATSERVICE_TAG
    docker tag ghcr.io/eclipse/kuksa.val.services/seat_service:$SEATSERVICE_TAG localhost:12345/seatservice:$SEATSERVICE_TAG
    docker push localhost:12345/seatservice:$SEATSERVICE_TAG

    docker pull ghcr.io/eclipse/kuksa.val.feeders/dbc2val:$FEEDERCAN_TAG
    docker tag ghcr.io/eclipse/kuksa.val.feeders/dbc2val:$FEEDERCAN_TAG localhost:12345/feedercan:$FEEDERCAN_TAG
    docker push localhost:12345/feedercan:$FEEDERCAN_TAG

    # We set the tag to the version from the variables above in the script. This overwrites the default values in the values-file.
    helm install vehicleappruntime $ROOT_DIRECTORY/deploy/runtime/k3d/helm --values $ROOT_DIRECTORY/deploy/runtime/k3d/helm/values.yaml --set imageSeatService.tag=$SEATSERVICE_TAG --set imageVehicleDataBroker.tag=$VEHICLEDATABROKER_TAG --set imageFeederCan.tag=$FEEDERCAN_TAG --wait --timeout 60s --debug

else
    echo "Runtime already deployed. To redeploy the components, run the task 'K3D - Uninstall runtime' first."
fi

helm status vehicleappruntime
kubectl get svc --all-namespaces
kubectl get pods
