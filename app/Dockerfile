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

# syntax=docker/dockerfile:1.2

# Build stage, to create the executable
FROM --platform=$TARGETPLATFORM python:3.10-slim-bullseye@sha256:1ee6094f44c67781fa9533a4215f44f80dd3f43a68751ad2c855712116c03b05 as builder

RUN apt-get update && apt-get install -y binutils

COPY ./app /app
COPY ./gen/vehicle_model /vehicle_model

# Remove this installation for Arm64 once staticx has a prebuilt wheel for Arm64
RUN /bin/bash -c 'set -ex && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "aarch64" ]; then \
    echo "ARM64" && \
    apt-get install -y gcc && \
    pip3 install --no-cache-dir scons; \
    fi'

RUN apt-get install -y git
RUN pip3 install --no-cache-dir pyinstaller \
    && pip3 install --no-cache-dir patchelf==0.17.0.0 \
    && pip3 install --no-cache-dir staticx \
    && pip3 install --no-cache-dir -r ./app/requirements.txt \
    && pip3 install --no-cache-dir -r ./app/requirements-links.txt \
    && pip3 install --no-cache-dir /vehicle_model

WORKDIR /app

RUN pyinstaller --clean -F -s src/main.py

WORKDIR /app/dist

RUN staticx main run-exe

# Runner stage, to copy the executable
FROM scratch

COPY --from=builder ./app/dist/run-exe /dist/

WORKDIR /tmp
WORKDIR /dist

ENV PATH="/dist:$PATH"

LABEL org.opencontainers.image.source="https://github.com/eclipse-velocitas/vehicle-app-python-template"

CMD ["./run-exe"]
