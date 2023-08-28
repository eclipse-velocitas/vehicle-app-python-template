#!/bin/bash

package_name=jq ".packages[0].name" .velocitas.json
package_version=jq ".packages[0].version" .velocitas.json

cp /workspaces/vehicle-app-python-template/.velocitas.json "/home/vscode/.velocitas/packages/${package_name}/${package_version}/.velocitas.json"
velocitas exec runtime-k3d test
velocitas exec runtime-k3d down
