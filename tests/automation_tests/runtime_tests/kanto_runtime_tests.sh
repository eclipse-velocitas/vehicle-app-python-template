#!/bin/bash

package_name=$(jq ".packages[0].name" .velocitas.json | sed -e 's/^"//' -e 's/"$//')
package_version=$(jq ".packages[0].version" .velocitas.json | sed -e 's/^"//' -e 's/"$//')

cp /workspaces/vehicle-app-python-template/.velocitas.json "/home/vscode/.velocitas/packages/$package_name/$package_version/.velocitas.json"
velocitas exec runtime-kanto test
# velocitas exec runtime-kanto down