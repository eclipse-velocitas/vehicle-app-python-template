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

export HTTP_PROXY=${HTTP_PROXY}
export HTTPS_PROXY=${HTTPS_PROXY}
export NO_PROXY=${NO_PROXY}

echo "#######################################################"
echo "### Checking container creation                     ###"
echo "#######################################################"

echo "## checking if user 'vscode' was created by common-debian.sh"
if id -u vscode > /dev/null 2>&1; then
    echo "## found existing user 'vscode'"
else
    echo "## WARNING: failed to find user 'vscode'. Adding user 'vscode' directly as a fallback"
    useradd vscode --password vscode -m
    apt-get install sudo
    usermod -aG sudo vscode
    sleep 5
fi
