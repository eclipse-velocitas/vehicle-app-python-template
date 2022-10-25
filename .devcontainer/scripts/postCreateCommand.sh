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
echo "### Install python requirements                     ###"
echo "#######################################################"
REQUIREMENTS="./requirements-dev.txt"
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

# Required because of a bug in virtualenv
# until PR is released
# https://github.com/pypa/virtualenv/pull/2415
pip3 install setuptools==59.6.0

# Required because of pre-commit
# dependency to python-Levenshtein
# wheels are missing and have to built from scratch
sudo apt-get update && sudo apt-get install -y build-essential python3-dev
