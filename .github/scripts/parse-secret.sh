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

echo "Script executed from: ${PWD}"
temp=$OTA_SYSTEM_CREDENTIALS

CONTAINER_REGISTRY=$(echo $temp | jq -r '.CONTAINER_REGISTRY')

REGISTRY_USER=$(echo $temp | jq -r '.REGISTRY_USER')

REGISTRY_PASSWORD=$(echo $temp | jq -r '.REGISTRY_PASSWORD')

echo "::add-mask::$REGISTRY_PASSWORD"

echo "CONTAINER_REGISTRY=$CONTAINER_REGISTRY" >> $GITHUB_ENV
echo "REGISTRY_USER=$REGISTRY_USER" >> $GITHUB_ENV
echo "REGISTRY_PASSWORD=$REGISTRY_PASSWORD" >> $GITHUB_ENV

printenv
