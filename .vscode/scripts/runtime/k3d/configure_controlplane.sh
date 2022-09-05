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

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )
DAPR_RUNTIME=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].dependencies.dapr.runtime.version | tr -d '"')

if ! k3d registry get k3d-registry.localhost &> /dev/null
then
  k3d registry create registry.localhost --port 12345
else
  echo "Registry already exists."
fi

if ! k3d cluster get cluster &> /dev/null
then

  if [ -n "$HTTP_PROXY" ]; then
    echo "Creating cluster with proxy configuration"
    k3d cluster create cluster \
      --registry-use k3d-registry.localhost:12345 \
      -p "31883:31883" \
      -p "30555:30555" \
      -p "30051:30051" \
      -e "HTTP_PROXY=$HTTP_PROXY@server:0" \
      -e "HTTPS_PROXY=$HTTPS_PROXY@server:0" \
      --volume $ROOT_DIRECTORY/deploy/runtime/k3d/volume:/mnt/data@server:0 \
      -e "NO_PROXY=localhost@server:0"
  else
    echo "Creating cluster without proxy configuration"
    k3d cluster create cluster \
      -p "30555:30555" \
      -p "31883:31883" \
      -p "30051:30051" \
      --volume $ROOT_DIRECTORY/deploy/runtime/k3d/volume:/mnt/data@server:0 \
      --registry-use k3d-registry.localhost:12345
  fi

else
  echo "Cluster already exists."
fi

if ! kubectl get deployment zipkin &> /dev/null
then
  # Deploy Zipkin
  kubectl create deployment zipkin --image openzipkin/zipkin
  kubectl expose deployment zipkin --type ClusterIP --port 9411
else
  echo "Zipkin is already deployed."
fi

if ! dapr status -k &> /dev/null
then
  # Init Dapr in cluster. The --runtime-version is used to specify the dapr runtime version (i.e. remove the '#')
  # Dapr runtime releases: https://github.com/dapr/dapr/releases
  dapr init -k --wait --timeout 600 --runtime-version $DAPR_RUNTIME

  # Apply Dapr config
  kubectl apply -f $ROOT_DIRECTORY/deploy/runtime/k3d/.dapr/config.yaml
  kubectl apply -f $ROOT_DIRECTORY/deploy/runtime/k3d/.dapr/components/pubsub.yaml
else
  echo "Dapr is already initialized with K3D"
fi
