#!/bin/bash

### K3D runtime tests
./tests/automation_tests/runtime_tests/k3d_runtime_tests.sh

if [ $? -ne 0 ]
then
   exit $?
fi

### Kanto runtime tests
./tests/automation_tests/runtime_tests/kanto_runtime_tests.sh
if [ $? -ne 0 ]
then
   exit $?
fi

### Local runtime tests
./tests/automation_tests/runtime_tests/local_runtime_tests.sh
if [ $? -ne 0 ]
then
   exit $?
fi

echo -e "\033[0;32m Test passed !!!\033[0m"
