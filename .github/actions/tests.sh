#!/bin/bash

set -e

npx cypress run --config specPattern=plugins/themes/pragma/cypress/tests/functional

