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

sudo chmod +x .devcontainer/scripts/*.sh

.devcontainer/scripts/setup-git.sh

if [[ -z "${VELOCITAS_OFFLINE}" ]]; then
    .devcontainer/scripts/configure-codespaces.sh
    .devcontainer/scripts/upgrade-cli.sh
fi

# Call user initialization hook if present
ON_CREATE_USER_HOOK_PATH=.devcontainer/scripts/onCreateUserHook.sh
if [[ -x $ON_CREATE_USER_HOOK_PATH ]]; then
    $ON_CREATE_USER_HOOK_PATH
fi

echo "#######################################################"
echo "### Run VADF Lifecycle Management                   ###"
echo "#######################################################"
velocitas init
velocitas sync

# Some setup might be required even in offline mode
.devcontainer/scripts/setup-dependencies.sh

echo "#######################################################"
echo "### VADF package status                             ###"
echo "#######################################################"
velocitas upgrade --dry-run --ignore-bounds

# Don't let container creation fail if lifecycle management fails
echo "Done!"
