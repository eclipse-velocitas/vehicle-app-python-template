# Copyright (c) 2023-2024 Contributors to the Eclipse Foundation
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

import os
import subprocess  # nosec
import unittest

from parameterized import parameterized

devenv_runtimes_path = (
    subprocess.check_output(["velocitas", "package", "-p", "devenv-runtimes"])  # nosec
    .decode("utf-8")
    .strip("\n")
)

os.environ["VDB_PORT"] = "30555"
os.environ["MQTT_PORT"] = "31883"


class RuntimeTest(unittest.TestCase):
    @parameterized.expand(["runtime_kanto", "runtime_local"])
    def test_runtime(self, runtime):
        subprocess.check_call(  # nosec
            [
                "pytest",
                "-s",
                "-x",
                (
                    f"{devenv_runtimes_path}/{runtime}/test/integration/"
                    f"integration_test.py::test_scripts_run_successfully"
                ),
            ]
        )
        subprocess.check_call(  # nosec
            ["pytest", "-s", "-x", "./app/tests/integration/integration_test.py"]
        )
        if runtime != "runtime_local":
            subprocess.check_call(  # nosec
                ["velocitas", "exec", runtime.replace("_", "-"), "down"]
            )
