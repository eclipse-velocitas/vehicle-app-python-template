# Copyright (c) 2023 Robert Bosch GmbH

# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# SPDX-License-Identifier: Apache-2.0

import subprocess
import unittest

from parameterized import parameterized

devenv_runtimes_path = (
    subprocess.check_output(["velocitas", "package", "-p", "devenv-runtimes"])
    .decode("utf-8")
    .strip("\n")
)

print(type(devenv_runtimes_path))


class RuntimeTest(unittest.TestCase):
    @parameterized.expand(["runtime-k3d", "runtime-kanto", "runtime-local"])
    def test_runtime(self, runtime):
        subprocess.check_call(
            [
                "pytest",
                "-s",
                "-x",
                (
                    f"{devenv_runtimes_path}/{runtime}/test/integration/"
                    f"integration_test.py"
                ),
            ]
        )
