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

if [[ -z "${VELOCITAS_OFFLINE}" ]]; then
    echo "#######################################################"
    echo "### Install python requirements                     ###"
    echo "#######################################################"
    # Update pip before installing requirements
    pip3 install --upgrade pip
    REQUIREMENTS="./requirements.txt"
    if [ -f $REQUIREMENTS ]; then
        pip3 install -r $REQUIREMENTS
    fi
    REQUIREMENTS="./app/requirements-links.txt"
    if [ -f $REQUIREMENTS ]; then
        pip3 install -r $REQUIREMENTS
    fi
    # Dependencies for the app
    REQUIREMENTS="./app/requirements.txt"
    if [ -f $REQUIREMENTS ]; then
        pip3 install -r $REQUIREMENTS
    fi

    # Dependencies for unit and integration tests
    REQUIREMENTS="./app/tests/requirements.txt"
    if [ -f $REQUIREMENTS ]; then
        pip3 install -r $REQUIREMENTS
    fi
fi
