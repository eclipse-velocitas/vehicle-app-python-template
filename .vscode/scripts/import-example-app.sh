#!/bin/bash
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

set -e

VELOCITAS_EXAMPLES_PATH="$(python -c 'import velocitas_examples; print(velocitas_examples.__path__[0])')"
CHOSEN_EXAMPLE=$@

if [[ `git status --porcelain app/` ]]; then
  echo "######################## WARNING #########################"
  echo "####  Please commit or stash your changes in the app  ####"
  echo "####  directory before an import is possible:         ####"
  echo "####  The content of the app directory needs being    ####"
  echo "####  completely replaced by the example code!        ####"
  echo "######################## WARNING #########################"
else
  rm -rf app/
  cp -r $VELOCITAS_EXAMPLES_PATH/$CHOSEN_EXAMPLE/. app/

  # Re-compile requirements*.txt (including app and tests one)
  pip-compile -r -q ./requirements.in
  # Re-intstall necessary packages in DevContainer
  for file in ./requirements.txt ./app/requirements.txt ./app/tests/requirements.txt ./app/requirements-links.txt
  do
      if [ -f $file ]; then
          pip3 install -r $file
      fi
  done

  # Generate model referenced by imported example
  velocitas exec vehicle-signal-interface download-vspec
  velocitas exec vehicle-signal-interface generate-model

  echo "#######################################################"
  echo "Successfully imported $@"
  echo "#######################################################"
fi
