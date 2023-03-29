#!/bin/bash
# This file is maintained by velocitas CLI, do not modify manually. Change settings in .velocitas.json
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

set -e

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../.." )
APP_NAME=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Name | tr -d '"' | tr '[:upper:]' '[:lower:]')
APP_PORT=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Port | tr -d '"')
APP_REGISTRY="k3d-registry.localhost:12345"
RUNTIME_VERSION=$(cat $ROOT_DIRECTORY/.velocitas.json | jq -r '.packages[]| select(.name=="devenv-runtime-k3d")'.version)
CONFIG_DIR="$HOME/.velocitas/packages/devenv-runtime-k3d/$RUNTIME_VERSION/src/deployment/config"

local_tag="$APP_REGISTRY/$APP_NAME:local"
echo "Local URL: $local_tag"

docker load -i "$APP_NAME.tar" | sed -n 's/^Loaded image ID: sha256:\([0-9a-f]*\).*/\1/p' | xargs -i docker tag {} $local_tag
docker push $local_tag

helm install vapp-chart $CONFIG_DIR/helm \
    --values $CONFIG_DIR/helm/values.yaml \
    --set imageVehicleApp.repository="$APP_REGISTRY/$APP_NAME" \
    --set imageVehicleApp.name=$APP_NAME \
    --set imageVehicleApp.daprAppid=$APP_NAME \
    --set imageVehicleApp.daprPort=$APP_PORT \
    --wait --timeout 60s --debug

kubectl get svc --all-namespaces
kubectl get pods

podname=$(kubectl get pods -o name | grep $APP_NAME)
kubectl describe $podname
kubectl logs $podname --all-containers
