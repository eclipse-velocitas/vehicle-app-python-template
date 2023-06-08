#!/bin/bash
mosquitto &

kanto-cm create --i --t --network host --e KUKSA_DATA_BROKER_PORT=55555 -n databroker ghcr.io/eclipse/kuksa.val/databroker:0.3
kanto-cm start -n databroker

docker run -d -p 5000:5000 --name registry registry:2
velocitas exec deployment-k3d build-vehicleapp
docker push localhost:12345/sampleapp:local

kanto-cm create --i --t --network host --e SDV_MIDDLEWARE_TYPE=native --e SDV_VEHICLEDATABROKER_ADDRESS=grpc://127.0.0.1:55555 --e SDV_MQTT_ADDRESS=mqtt://127.0.0.1:1883 -n sampleapp localhost:12345/sampleapp:local
kanto-cm start -n sampleapp
