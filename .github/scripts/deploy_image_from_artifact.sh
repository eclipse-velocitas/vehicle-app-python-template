#!/bin/bash
# This file is maintained by velocitas CLI, do not modify manually. Change settings in .velocitas.json
# Copyright (c) 2022-2024 Contributors to the Eclipse Foundation
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
APP_ARTIFACT_NAME=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq -r .name | tr -d '"')
APP_NAME_LOWERCASE=$(echo $APP_ARTIFACT_NAME | tr '[:upper:]' '[:lower:]')
APP_REGISTRY="localhost:12345"

local_tag="$APP_REGISTRY/$APP_NAME_LOWERCASE:local"
echo "Local URL: $local_tag"

docker load -i "$APP_ARTIFACT_NAME.tar" | cut -d ':' -f 3 | xargs -i docker tag {} $local_tag
docker push $local_tag

cd $ROOT_DIRECTORY
velocitas exec deployment-kanto deploy-vehicleapp
