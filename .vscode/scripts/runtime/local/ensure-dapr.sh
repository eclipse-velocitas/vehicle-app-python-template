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
echo "### Ensure dapr                                     ###"
echo "#######################################################"

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )
DEFAULT_DAPR_VERSION=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .dapr.version | tr -d '"')
DAPR_RUNTIME=$(cat $ROOT_DIRECTORY/prerequisite_settings.json | jq .dapr.runtime | tr -d '"')
INSTALLED_DAPR_VERSION=$(dapr --version | grep "CLI version: " | sed 's/^.*: //')

# If dapr is not installed, the runtime version will empty (i.e lenght = 0)
# If the runtime version is not empty, the version will be either:
# - Uninitialize: "n/a"
# - Initialize: "x.y.z"
if [ -z "$INSTALLED_DAPR_VERSION" ] || [ $INSTALLED_DAPR_VERSION != $DEFAULT_DAPR_VERSION ]; then
      echo "Install dapr $DEFAULT_DAPR_VERSION"
      wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash -s $DEFAULT_DAPR_VERSION
else
      echo "Dapr is already installed."
      echo "=========================="
      dapr --version
      echo "=========================="
fi

echo ">> Initialize/reinitialize dapr runtime $DAPR_RUNTIME ..."
dapr uninstall
dapr init  --runtime-version $DAPR_RUNTIME

echo "=========================="
dapr --version
echo "=========================="
