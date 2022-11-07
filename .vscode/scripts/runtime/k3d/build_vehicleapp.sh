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

ROOT_DIRECTORY=$( realpath "$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/../../../.." )
APP_NAME=$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Name | tr -d '"' | tr '[:upper:]' '[:lower:]')
DOCKERFILE_FILE="$(cat $ROOT_DIRECTORY/app/AppManifest.json | jq .[].Dockerfile | tr -d '"')"

if [ -n "$HTTP_PROXY" ]; then
    echo "Building image with proxy configuration"

    cd $ROOT_DIRECTORY
    DOCKER_BUILDKIT=1 docker build \
    -f $DOCKERFILE_FILE \
    --progress=plain \
    -t localhost:12345/$APP_NAME:local \
    --build-arg HTTP_PROXY="$HTTP_PROXY" \
    --build-arg HTTPS_PROXY="$HTTPS_PROXY" \
    --build-arg FTP_PROXY="$FTP_PROXY" \
    --build-arg ALL_PROXY="$ALL_PROXY" \
    --build-arg NO_PROXY="$NO_PROXY" . --no-cache

else
    echo "Building image without proxy configuration"
    # Build, push vehicleapi image - NO PROXY

    cd $ROOT_DIRECTORY
    DOCKER_BUILDKIT=1 docker build -f $DOCKERFILE_FILE --progress=plain -t localhost:12345/$APP_NAME:local . --no-cache
fi
