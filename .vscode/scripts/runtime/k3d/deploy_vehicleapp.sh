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

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )
APP_NAME=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Name | tr -d '"' | tr '[:upper:]' '[:lower:]')
APP_PORT=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Port | tr -d '"')
APP_REGISTRY="k3d-registry.localhost:12345"

docker push localhost:12345/$APP_NAME:local

helm uninstall vapp-chart --wait

# Deploy in K3D
helm install vapp-chart $ROOT_DIRECTORY/deploy/VehicleApp/helm \
    --values $ROOT_DIRECTORY/deploy/VehicleApp/helm/values.yaml \
    --set imageVehicleApp.repository="$APP_REGISTRY/$APP_NAME" \
    --set imageVehicleApp.name=$APP_NAME \
    --set imageVehicleApp.daprAppid=$APP_NAME \
    --set imageVehicleApp.daprPort=$APP_PORT \
    --wait --timeout 60s --debug
