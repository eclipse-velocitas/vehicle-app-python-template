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

# skip B101
# pylint: disable=C0413

from unittest import mock

import pytest
from sdv.vehicle_app import VehicleApp
from sdv_model import vehicle  # type: ignore

MOCKED_SPEED = 0.0


@pytest.mark.asyncio
async def test_for_get_speed():
    # Disable no-value-for-parameter, seems to be false positive with mock lib
    # pylint: disable=no-value-for-parameter
    with mock.patch.object(
        vehicle.OBD.Speed,
        "get",
        new_callable=mock.AsyncMock,
        return_value=MOCKED_SPEED,
    ):
        current_speed = await vehicle.OBD.Speed.get()
        assert current_speed == MOCKED_SPEED


@pytest.mark.asyncio
async def test_for_publish_to_topic():
    # Disable no-value-for-parameter, seems to be false positive with mock lib
    # pylint: disable=no-value-for-parameter

    with mock.patch.object(
        VehicleApp, "publish_mqtt_event", new_callable=mock.AsyncMock, return_value=-1
    ):
        response = await VehicleApp.publish_mqtt_event(
            str("sampleTopic"), get_sample_response_data()  # type: ignore
        )
        assert response == -1


def get_sample_response_data():
    return {
        "result": {
            "message": f"""Current Speed = {MOCKED_SPEED}""",
        },
    }
