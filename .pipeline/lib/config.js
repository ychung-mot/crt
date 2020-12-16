"use strict";
const options = require("pipeline-cli").Util.parseArguments();
const changeId = options.pr; //aka pull-request
const version = "1.0.0";
const name = "crt";

const phases = {
  build: {
    namespace: "2d982c-tools",
    name: `${name}`,
    phase: "build",
    changeId: changeId,
    suffix: `-build-${changeId}`,
    instance: `${name}-build-${changeId}`,
    version: `${version}-${changeId}`,
    tag: `build-${version}-${changeId}`,
    transient: true,
  },
  dev: {
    namespace: "2d982c-dev",
    name: `${name}`,
    phase: "dev",
    changeId: changeId,
    suffix: `-dev-${changeId}`,
    instance: `${name}-dev-${changeId}`,
    version: `${version}-${changeId}`,
    tag: `dev-${version}-${changeId}`,
    host: `crt-${changeId}-2d982c-dev.apps.silver.devops.gov.bc.ca`,
    url_prefix: "dev-",
    export_server: "devoas1",
    dotnet_env: "Development",
    transient: true,
  },
  test: {
    namespace: "2d982c-test",
    name: `${name}`,
    phase: "test",
    changeId: changeId,
    suffix: `-test`,
    instance: `${name}-test`,
    version: `${version}`,
    tag: `test-${version}`,
    host: `crt-2d982c-test.apps.silver.devops.gov.bc.ca`,
    url_prefix: "tst-",
    export_server: "tstoas2",
    dotnet_env: "Staging",
  },
  uat: {
    namespace: "2d982c-test",
    name: `${name}`,
    phase: "uat",
    changeId: changeId,
    suffix: `-uat`,
    instance: `${name}-uat`,
    version: `${version}`,
    tag: `uat-${version}`,
    host: `crt-2d982c-uat.apps.silver.devops.gov.bc.ca`,
    url_prefix: "uat-",
    export_server: "tstoas2",
    dotnet_env: "UAT",
  },
  prod: {
    namespace: "2d982c-prod",
    name: `${name}`,
    phase: "prod",
    changeId: changeId,
    suffix: `-prod`,
    instance: `${name}-prod`,
    version: `${version}`,
    tag: `prod-${version}`,
    host: `crt-2d982c-prod.apps.silver.devops.gov.bc.ca`,
    url_prefix: "",
    export_server: "prdoas2",
    dotnet_env: "Production",
  },
};

// This callback forces the node process to exit as failure.
process.on("unhandledRejection", (reason) => {
  console.log(reason);
  process.exit(1);
});

module.exports = exports = { phases, options };
