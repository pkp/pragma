#!/bin/bash

set -e

npx cypress run --spec "cypress/tests/data/10-ApplicationSetup/*.cy.js,cypress/tests/data/60-content/VkarbasizaedSubmission.cy.js"

npx cypress run --headless --browser chrome  --config '{"specPattern":["plugins/themes/pragma/cypress/tests/functional/*.cy.js"]}'
