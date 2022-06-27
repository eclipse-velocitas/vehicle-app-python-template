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

if k3d cluster get cluster &> /dev/null
then
    echo "Uninstalling runtime..."
    k3d cluster delete cluster
else
    echo "Control plane is not configured, skipping cluster deletion."
fi

if k3d registry list | grep k3d-registry.localhost &> /dev/null
then
    echo "Uninstalling runtime..."
    k3d registry delete k3d-registry.localhost
else
    echo "Registry does not exist, skipping deletion."
fi
