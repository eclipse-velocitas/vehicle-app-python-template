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

version=$(dapr --version | grep "Runtime version: " | sed 's/^.*: //')

if ! [[ $version =~ ^([0-9]{1,2})\.([0-9]{1,2})\.([0-9]{1,2}) ]]; then
      daprReleaseUrl="https://api.github.com/repos/dapr/cli/releases"
      latest_release=$(curl -s $daprReleaseUrl | grep \"tag_name\" | grep -v rc | awk 'NR==1{print $2}' |  sed -n 's/\"\(.*\)\",/\1/p')
      if [ -z "$latest_release" ]
      then
            echo "Installing dapr pre-defined version: 1.6.0"
            wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash -s 1.6.0
      else
            echo "Installing dapr latest version: $latest_release"
            wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash
      fi

      dapr uninstall
      dapr init --runtime-version 1.8.0-rc.3
else
      echo "Dapr is already installed and initialized, skipping setup."
fi

dapr --version
