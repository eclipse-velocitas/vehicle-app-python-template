# How to Contribute to Eclipse Velocitas Vehicle App Python Template

First of all, thanks for considering to contribute to Eclipse Velocitas. We really
appreciate the time and effort you want to spend helping to improve things around here.

In order to get you started as fast as possible we need to go through some organizational issues first, though.

## Eclipse Contributor Agreement

Before your contribution can be accepted by the project team contributors must
electronically sign the Eclipse Contributor Agreement (ECA).

* http://www.eclipse.org/legal/ECA.php

Commits that are provided by non-committers must have a Signed-off-by field in
the footer indicating that the author is aware of the terms by which the
contribution has been provided to the project. The non-committer must
additionally have an Eclipse Foundation account and must have a signed Eclipse
Contributor Agreement (ECA) on file.

For more information, please see the Eclipse Committer Handbook:
https://www.eclipse.org/projects/handbook/#resources-commit

## Code Style Guide
* Use [Black](https://black.readthedocs.io/) to format your code.
* Use [isort](https://isort.readthedocs.io/) to sort imports.
* Use [pydocstyle](https://pydocstyle.readthedocs.io/) to check for PEP-8 style issues.
* Use [bandit](https://pypi.org/project/bandit/) to check security issues.
* Use [mypy](https://mypy.readthedocs.io/) to check for type errors.
* Use [flake8](https://flake8.readthedocs.io/) to check for style issues.
* Above and other tools will run automatically if you install
 [pre-commit](https://pre-commit.com/) using the instructions below.

## Making Your Changes

* Fork the repository on GitHub.
* Create a new branch for your changes.
* Install dependencies:

   ```bash
   pip3 install -r requirements-dev.txt
   ```
* Make your changes following the code style guide (see Code Style Guide section above).
* When you create new files make sure you include a proper license header at the top of the file (see License Header section below).
* Install and run [pre-commit](https://pre-commit.com/) to automatically check for style guide issues.
    ```bash
    pre-commit install
    pre-commit run --all-files
    ```
   > **_NOTE:_** Or just use task `Local - Pre Commit Action` by pressing `F1` and select `Tasks - Run Task`
* Make sure the unit and integration test suites passes after your changes.
* Commit your changes into that branch.
* Use descriptive and meaningful commit messages. Start the first line of the commit message with the issue number and title e.g. `[#9865] Add token based authentication`.
* Squash multiple commits that are related to each other semantically into a single one.
* Make sure you use the `-s` flag when committing as explained above.
* Push your changes to your branch in your forked repository.

## Python Dependency Management

In this project, the [pip-tools](https://github.com/jazzband/pip-tools) are used to manage the python dependencies and to keep all packages up-to-date. The required pip-based dependencies of this project are defined in multiple `requirement` input files.

### Vehicle app runtime dependencies
* The [./app/requirements.in](./app/requirements.in) file is the requirement input file that used to generate the Vehicle app runtime requirements file [./app/requirements-txt.txt](./app/requirements.txt)

### Unit and Integration testing dependencies
* The [./app/tests/requirements-tests.in](./app/tests/requirements-tests.in) file is the requirement input file that used to generate the testing requirements file [./app/tests/requirements-tests.txt](./app/tests/requirements-tests.txt). The test requirements file needs to be installed for the development container to execute the unit and integration tests as well as in the CI Workflow test execution.

### Development tools dependencies
* The [./requirements-dev.in](./requirements-dev.in) file is the requirement input file that used to generate requirements file [./requirements-dev.txt](./requirements-dev.txt) for the other development tools. The development requirements list includes all the necessary packages testing and development tools packages and need to be installed before start contributing to the project. The development requirements (i.e. [./requirements-dev.in](./requirements-dev.in) are also aligned with the testing and runtime requirements for better dependency conflict management with the specified constrains.

The process to manage the dependencies of this project can be summarized as following:
* The `pip-compile` tool will generate the corresponding python `requirements`. When executing this tools for a specific requirements input file, the python `"requirements<<type>>.txt"` file will be updated with all underlying dependencies. The command below shall be executed every time a new python package is added to the project and/or to bump the package versions.

   ```bash
   pip-compile <<path-to-requirements.txt>>
   ```

* Run `pip-sync` or `pip install` to install the required dependencies from all requirement files alternatively.
   ```bash
   pip-sync <<path-to-requirements.txt>>
   ```
   ```bash
   pip3 install -r <<path-to-requirements.txt>>
   ```

If there are any other `none public python dependencies` (E.g. GitHub links), they shall not be added to the requirement files directly. Instead, they must be added to the [requirements-links.txt](./app/requirements-links.txt).

> **_NOTE:_** `Please don't try to update the versions of the dependencies manually.`

## License Header

Please make sure any file you newly create contains a proper license header like this:

```python
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
```
Please adjusted the comment character to the specific file format.

## Submitting the Changes

Submit a pull request via the normal GitHub UI.

## After Submitting

* Do not use your branch for any other development, otherwise further changes that you make will be visible in the PR.
