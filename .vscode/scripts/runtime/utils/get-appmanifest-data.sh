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
echo "### Getting AppManifest Data                        ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )

DEPENDENCIES=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].dependencies)
SERVICES=$(echo $DEPENDENCIES | jq '.services')
RUNTIME=$(echo $DEPENDENCIES | jq '.runtime')

if [ "$SERVICES" = "null" ];then
    echo "No Services defined in AppManifest";
else
    readarray -t SERVICES_ARRAY < <(echo $SERVICES | jq -c '.[]')
    # Exports content from service dependency configuration to ENV
    # $<SERVICENAME>_TAG=version
    # $<SERVICENAME>_IMAGE=image
    for service in ${SERVICES_ARRAY[@]}; do
        name=$(jq '.name' <<< "${service}" | tr -d '"')
        version=$(jq '.version' <<< "${service}" | tr -d '"')
        image=$(jq '.image' <<< "${service}" | tr -d '"')
        export ${name^^}_TAG=$version
        export ${name^^}_IMAGE=$image
    done
fi


if [ "$RUNTIME" = "null" ];then
    echo "No Runtime defined in AppManifest";
else
    readarray -t RUNTIME_ARRAY < <(echo $RUNTIME | jq -c '.[]')
    # Exports content from runtime dependency configuration to ENV
    # $<RUNTIMENAME>_TAG=version
    # $<RUNTIMENAME>_IMAGE=image
    for runtime in ${RUNTIME_ARRAY[@]}; do
        name=$(jq '.name' <<< "${runtime}" | tr -d '"')
        version=$(jq '.version' <<< "${runtime}" | tr -d '"')
        image=$(jq '.image' <<< "${runtime}" | tr -d '"')
        export ${name^^}_TAG=$version
        export ${name^^}_IMAGE=$image
    done
fi
