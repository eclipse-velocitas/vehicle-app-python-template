#!/bin/bash
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

echo "#######################################################"
echo "### Configure-proxies                               ###"
echo "#######################################################"

echo "Use proxies: $USE_PROXIES"
echo "Username: $USERNAME"
echo "Http-proxy: $HTTP_PROXY"
echo "Https-proxy: $HTTPS_PROXY"
echo "Ftp-proxy: $FTP_PROXY"
echo "All proxy: $ALL_PROXY"
echo "No proxy: $NO_PROXY"
echo "Configure git: $CONFIGURE_GIT"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

echo "USERNAME parameter is ${USERNAME}"

# Determine the appropriate non-root user
# This recognizes the same possible user names found in Microsoft base Docker images
# as the scripts in the ../library-scripts directory
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in ${POSSIBLE_USERS[@]}; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

if [ "${USERNAME}" = "" ]; then
        USERNAME=vscode
fi
echo "Selected user name is ${USERNAME}"

echo "USE_PROXIES is ${USE_PROXIES}"
if [ "${USE_PROXIES}" = "true" ]; then
    echo "Configuring proxies"
    echo "HTTP_PROXY is ${HTTP_PROXY}"
    echo "HTTPS_PROXY is ${HTTPS_PROXY}"
    echo "FTP_PROXY is ${FTP_PROXY}"
    echo "ALL_PROXY is ${ALL_PROXY}"
    echo "NO_PROXY is ${NO_PROXY}"

    mkdir -p /home/${USERNAME}
    echo "export HTTP_PROXY=\"${HTTP_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export http_proxy=\"${HTTP_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export HTTPS_PROXY=\"${HTTPS_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export https_proxy=\"${HTTPS_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export FTP_PROXY=\"${FTP_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export ftp_proxy=\"${FTP_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export ALL_PROXY=\"${ALL_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export all_proxy=\"${ALL_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export NO_PROXY=\"${NO_PROXY}\"" >> /home/${USERNAME}/.profile
    echo "export no_proxy=\"${NO_PROXY}\"" >> /home/${USERNAME}/.profile

    # proxy settings to pass as VMARGS to Java
    JAVA_HTTP_PROXY_HOST=$(echo $HTTP_PROXY | sed 's/http:\/\/\(.*\):.*/\1/')
    JAVA_HTTP_PROXY_PORT=$(echo $HTTP_PROXY | sed 's/http:\/\/.*:\(.*\)/\1/' | tr -d '/')
    JAVA_HTTPS_PROXY_HOST=${JAVA_HTTP_PROXY_HOST} # assume it is the same proxy - change if required
    JAVA_HTTPS_PROXY_PORT=${JAVA_HTTP_PROXY_PORT} # assume it is the same proxy - change if required
    JAVA_NO_PROXY=$(echo $NO_PROXY | sed 's/,/\|/g' | tr -d '[:blank:]')
    echo "export JAVA_VMARGS_PROXIES=\"-Dhttp.proxyHost=${JAVA_HTTP_PROXY_HOST} -Dhttp.proxyPort=${JAVA_HTTP_PROXY_PORT} \
        -Dhttps.proxyHost=${JAVA_HTTPS_PROXY_HOST} -Dhttps.proxyPort=${JAVA_HTTPS_PROXY_PORT} \
        -Dhttp.nonProxyHosts=${JAVA_NO_PROXY}\"" >> /home/${USERNAME}/.profile

    # # Apply common tools proxy settings for installed tools
    if [ "${CONFIGURE_GIT}" = "true" ]; then
        su -c "git config --global http.proxy ${HTTP_PROXY}" ${USERNAME}
        su -c "git config --global https.proxy ${HTTPS_PROXY}" ${USERNAME}

        git config --global http.proxy ${HTTP_PROXY}
        git config --global https.proxy ${HTTPS_PROXY}
    fi

    echo "# Proxy settings" >> /etc/wgetrc
    echo "http_proxy=${HTTP_PROXY}" >> /etc/wgetrc
    echo "https_proxy=${HTTPS_PROXY}" >> /etc/wgetrc
    echo "ftp_proxy=${FTP_PROXY}" >> /etc/wgetrc
    echo "no_proxy=${NO_PROXY}" >> /etc/wgetrc
    echo "use_proxy=on" >> /etc/wgetrc

    # enable root user to "apt-get" via proxy
    echo "Acquire::http::proxy \"${HTTP_PROXY}\";" >> /etc/apt/apt.conf
    echo "Acquire::https::proxy \"${HTTPS_PROXY}\";" >> /etc/apt/apt.conf
fi

exit 0
