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

import unittest
from pathlib import Path

import pkg_resources
from parameterized import parameterized


class TestRequirements(unittest.TestCase):
    """Test availability of required packages."""

    @parameterized.expand(
        ["./requirements.txt", "./app/requirements.txt", "./app/tests/requirements.txt"]
    )
    def test_requirements(self, requirement_file_path):
        """Test that each required package is available."""
        requirements = pkg_resources.parse_requirements(
            Path(requirement_file_path).open()
        )
        for requirement in requirements:
            requirement = str(requirement)
            with self.subTest(requirement=requirement):
                pkg_resources.require(requirement)
