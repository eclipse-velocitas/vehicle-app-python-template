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

# pylint: disable=C0321
import json

import pytest
from sdv.test.inttesthelper import IntTestHelper
from sdv.test.mqtt_util import MqttClient

# GET_SPEED_REQUEST_TOPIC = "sampleapp/getSpeed"
# GET_SPEED_RESPONSE_TOPIC = "sampleapp/getSpeed/response"


@pytest.mark.asyncio
async def test_get_current_speed():
    mqtt_client = MqttClient()
    inttesthelper = IntTestHelper()
    print(f"{mqtt_client} can be used when your app compiles succesfully!")
    print(f"{inttesthelper} can be used when your app compiles succesfully!")

    # When your app compiles succesfully use the inttesthelper to get viable responses
    response = "{}"
    # response = await inttesthelper.set_float_datapoint(
    #     name="Vehicle.Speed", value=0
    # )

    # assert len(response.errors) == 0

    # response = mqtt_client.publish_and_wait_for_response(
    #     request_topic=GET_SPEED_REQUEST_TOPIC,
    #     response_topic=GET_SPEED_RESPONSE_TOPIC,
    #     payload={},
    # )

    body = json.loads(response)
    # add expected message to get it assert
    expected_message = "Current Speed = 0.0"

    print(f"Received response: {body}")
    print(f"Expected message: {expected_message}")

    # Uncomment to test the behaviour of the SampleApp as provided by
    #     the template repository:
    # assert body["result"]["status"] == 0
    # assert body["result"]["message"] == expected_message
