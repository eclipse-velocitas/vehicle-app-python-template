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

# skip B101


MOCKED_SPEED = 0.0


def test_dummy():
    pass


# @pytest.mark.asyncio
# async def test_for_get_speed():
#     result = TypedDataPointResult("foo", MOCKED_SPEED, Timestamp(seconds=10, nanos=0))

#     with mock.patch.object(
#         vehicle.Speed,
#         "get",
#         new_callable=mock.AsyncMock,
#         return_value=result,
#     ):
#         current_speed = (await vehicle.Speed.get()).value
#         print(f"Received speed: {current_speed}")
#         # Uncomment to test the behaviour of the SampleApp as provided by
#         #     the template repository:
#         # assert current_speed == MOCKED_SPEED


# @pytest.mark.asyncio
# async def test_for_publish_to_topic():
#     with mock.patch.object(
#         VehicleApp, "publish_mqtt_event", new_callable=mock.AsyncMock, return_value=-1
#     ):
#         response = await VehicleApp.publish_mqtt_event(
#             str("sampleTopic"),  # type: ignore
#             get_sample_response_data(),
#         )

#         print(f"Received response: {response}")
#         # Uncomment to test the behaviour of the SampleApp as provided by
#         #     the template repository:
#         # assert response == -1


def get_sample_response_data():
    return {
        "result": {
            "message": f"""Current Speed = {MOCKED_SPEED}""",
        },
    }
