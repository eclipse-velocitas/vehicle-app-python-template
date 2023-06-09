#!/bin/bash

kanto-cm remove -f -n databroker
kanto-cm remove -f -n sampleapp

docker rm registry -f
pkill -f mosquitto
sudo pkill -1 -f container-management
