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

FROM ghcr.io/eclipse-velocitas/devcontainer-base-images/python:v0.3

ENV DOCKER_BUILDKIT=1

COPY scripts/*.sh /tmp/scripts/
RUN find /tmp/scripts/ -type f -iname "*.sh" -exec chmod +x {} \;
RUN /bin/bash /tmp/scripts/container-set.sh
RUN /bin/bash /tmp/scripts/configure-proxies.sh
