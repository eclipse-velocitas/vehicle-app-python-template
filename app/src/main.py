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

import asyncio
import json
import logging
import signal
from datetime import datetime

from vehicle import Vehicle, vehicle  # type: ignore
from velocitas_sdk.model import DataPoint
from velocitas_sdk.util.log import (  # type: ignore
    get_opentelemetry_log_factory,
    get_opentelemetry_log_format,
)
from velocitas_sdk.vdb.reply import DataPointReply
from velocitas_sdk.vehicle_app import VehicleApp

# Configure the VehicleApp logger with the necessary log config and level.
logging.setLogRecordFactory(get_opentelemetry_log_factory())
logging.basicConfig(format=get_opentelemetry_log_format())
logging.getLogger().setLevel("DEBUG")
logger = logging.getLogger(__name__)

GET_SPEED_REQUEST_TOPIC = "sampleapp/getSpeed"
GET_SPEED_RESPONSE_TOPIC = "sampleapp/getSpeed/response"
DATABROKER_SUBSCRIPTION_TOPIC = "sampleapp/currentSpeed"


class PerformanceTestApp(VehicleApp):
    """
    A sample vehicle app that subscribes to a list of signals (from a file) and prints
    the values + timestamps of the signals.
    """

    def __init__(self, vehicle_client: Vehicle):
        super().__init__()
        self.Vehicle = vehicle_client

    async def on_start(self):
        test_signals_json = self.read_json("app/testapp_performance_subscription.json")

        for signal_json in test_signals_json:
            signal_str = signal_json["Signal"]
            await self.subscribe(signal_str)

    def read_json(self, file_path: str):
        with open(file_path, "r") as file:
            return json.load(file)

    async def subscribe(self, signal_str: str):
        try:
            node: DataPoint = self.Vehicle.getNode(signal_str)  # type: ignore
            await node.subscribe(self.on_node_change)
        except AttributeError:
            print(f"Signal {signal_str} not found in the vehicle model.")

    async def on_node_change(self, data: DataPointReply):
        current_timestamp = datetime.now()

        datapoint_str = data.reply.fields.popitem()[0]
        node = self.Vehicle.getNode(datapoint_str=datapoint_str)
        data_point_value = data.get(node).value  # type: ignore

        print(f"{current_timestamp.time()} - {node.name} - {data_point_value}")


async def main():
    """Main function"""
    logger.info("Starting SampleApp...")
    # Constructing SampleApp and running it.
    vehicle_app = PerformanceTestApp(vehicle)
    await vehicle_app.run()


LOOP = asyncio.get_event_loop()
LOOP.add_signal_handler(signal.SIGTERM, LOOP.stop)
LOOP.run_until_complete(main())
LOOP.close()
