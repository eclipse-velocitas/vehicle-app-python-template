#!/bin/bash

if ! hash mosquitto &> /dev/null
then
     sudo apt update
     sudo apt install -y mosquitto
fi

if ! hash container-management &> /dev/null
then
     if ! [ -f kanto_0.1.0-M3_linux_arm64.deb ]; then
          wget https://github.com/eclipse-kanto/kanto/releases/download/v0.1.0-M3/kanto_0.1.0-M3_linux_arm64.deb
     fi
     sudo apt install ./kanto_0.1.0-M3_linux_arm64.deb

     if ! [-f eclipse-leda-kantui_0.0.2.0.00680_arm64.deb]; then
          wget https://github.com/eclipse-leda/leda-utils/releases/download/v0.0.2/eclipse-leda-kantui_0.0.2.0.00680_arm64.deb
     fi
     sudo apt install ./eclipse-leda-kantui_0.0.2.0.00680_arm64.deb
fi


sudo container-management --cfg-file config.json &

until [ -e /run/container-management/container-management.sock ]
do
     echo "waiting"
     sleep 1
done

sudo chmod a+rw /run/container-management/container-management.sock
