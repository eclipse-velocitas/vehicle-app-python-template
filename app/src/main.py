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

"""A sample skeleton vehicle app."""

# pylint: disable=C0103, C0413, E1101

import asyncio
import json
import logging
import signal

from sdv.util.log import (  # type: ignore
    get_opentelemetry_log_factory,
    get_opentelemetry_log_format,
)
from sdv.vehicle_app import VehicleApp, subscribe_topic
from sdv_model import Vehicle, vehicle  # type: ignore

logging.setLogRecordFactory(get_opentelemetry_log_factory())
logging.basicConfig(format=get_opentelemetry_log_format())
logging.getLogger().setLevel("INFO")
logger = logging.getLogger(__name__)

GET_SPEED_REQUEST_TOPIC = "sampleapp/getSpeed"
GET_SPEED_RESPONSE_TOPIC = "sampleapp/getSpeed/response"
DATABROKER_SUBSCRIPTION_TOPIC = "sampleapp/currentSpeed"


class SampleApp(VehicleApp):
    """
    Sample skeleton vehicle app.

    The skeleton subscribes to a getSpeed MQTT topic
    to listen for incoming requests to get
    the current vehicle speed and publishes it to
    a response topic.

    It also subcribes to the VehicleDataBroker
    directly for updates of the
    Vehicle.OBD.Speed signal and publishes this
    information via another specific MQTT topic
    """

    def __init__(self, vehicle_client: Vehicle):
        # SampleApp inherits from VehicleApp.
        super().__init__()
        self.Vehicle = vehicle_client

    async def on_start(self):
        """Run when the vehicle app starts"""
        logger.info("SampleApp started.")
        # Example to subscribe to VehicleDataBroker signals
        # on start of the app and defining method to execute on change.
        await self.Vehicle.OBD.Speed.subscribe(self.on_speed_change)

    # Is executed when receiving VehicleDataBroker signal.
    async def on_speed_change(self, data):
        logger.debug("Data received: %s", data)
        # Getting current speed from VehicleDataBroker.
        vehicle_speed = await self.Vehicle.OBD.Speed.get()
        # Publishes current speed to DATABROKER_SUBSCRIPTION_TOPIC.
        await self.publish_mqtt_event(
            DATABROKER_SUBSCRIPTION_TOPIC,
            json.dumps({"speed": vehicle_speed}),
        )

    # SampleApp subscribes to GET_SPEED_REQUEST_TOPIC
    # and executes the following method
    # when a message is published to GET_SPEED_REQUEST_TOPIC.
    @subscribe_topic(GET_SPEED_REQUEST_TOPIC)
    async def on_get_speed_request_received(self, data_str: str) -> None:
        logger.debug("Data received: %s", data_str)
        logger.info(
            "SampleApp received message from topic: %s", GET_SPEED_REQUEST_TOPIC
        )
        logger.info("SampleApp requests current speed from vehicle")
        # Getting current speed from VehicleDataBroker.
        vehicle_speed = await self.Vehicle.OBD.Speed.get()

        logger.info("Current speed is: %s", vehicle_speed)
        logger.info("Publishing response to topic: %s", GET_SPEED_RESPONSE_TOPIC)

        # Publishes current speed to GET_SPEED_RESPONSE_TOPIC.
        await self.publish_mqtt_event(
            GET_SPEED_RESPONSE_TOPIC,
            json.dumps(
                {
                    "result": {
                        "status": 0,
                        "message": f"""Current Speed = {vehicle_speed}""",
                    },
                }
            ),
        )


async def main():

    """Main function"""
    logger.info("Starting SampleApp...")
    # Constructing SampleApp and running it.
    vehicle_app = SampleApp(vehicle)
    await vehicle_app.run()


LOOP = asyncio.get_event_loop()
LOOP.add_signal_handler(signal.SIGTERM, LOOP.stop)
LOOP.run_until_complete(main())
LOOP.close()
