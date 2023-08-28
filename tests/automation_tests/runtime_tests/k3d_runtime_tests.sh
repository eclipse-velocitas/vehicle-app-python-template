#!/bin/bash

cp /workspaces/vehicle-app-python-template/.velocitas.json /home/vscode/.velocitas/packages/devenv-runtimes/automated-tests/.velocitas.json
velocitas exec runtime-k3d test
velocitas exec runtime-k3d down
