#!/bin/bash
# Copyright (c) 2023 Robert Bosch GmbH and Microsoft Corporation
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

package_name=$(jq ".packages[0].name" .velocitas.json | sed -e 's/^"//' -e 's/"$//')
package_version=$(jq ".packages[0].version" .velocitas.json | sed -e 's/^"//' -e 's/"$//')
chosen_runtime=$@

cp /workspaces/vehicle-app-python-template/.velocitas.json "/home/vscode/.velocitas/packages/$package_name/$package_version/.velocitas.json"
velocitas exec $chosen_runtime test
