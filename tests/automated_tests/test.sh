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

# Copyright (c) 2023 Robert Bosch GmbH
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

exit_if_not_successful() {
   if [ $? -ne 0 ]
   then
      exit $?
   fi
}

for runtime in runtime-k3d runtime-kanto runtime-local
do
   ./tests/automated_tests/runtime_tests.sh $runtime
   exit_if_not_successful
done

pytest tests/automated_tests/requirements_tests.py
exit_if_not_successful

./tests/automated_tests/import_example_test.sh
exit_if_not_successful

echo "#####################"
echo -e "##\033[0;32m Test passed !!!\033[0m ##"
echo "#####################"
