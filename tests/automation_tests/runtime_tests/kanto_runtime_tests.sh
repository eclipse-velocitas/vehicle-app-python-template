#!/bin/bash

package_name=$(jq ".packages[0].name" .velocitas.json | sed -e 's/^"//' -e 's/"$//')
package_version=$(jq ".packages[0].version" .velocitas.json | sed -e 's/^"//' -e 's/"$//')

velocitas exec runtime-kanto test
# velocitas exec runtime-kanto down