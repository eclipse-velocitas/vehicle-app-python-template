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

echo "#######################################################"
echo "### Setup Git                                       ###"
echo "#######################################################"
# Add git name and email from env variables
if [[ -n "${GIT_CONFIG_NAME}" && -n "${GIT_CONFIG_EMAIL}" ]]; then
    git config --global user.name $GIT_CONFIG_NAME
    git config --global user.email $GIT_CONFIG_EMAIL
fi

git config --global --add safe.directory "*"
