#!/bin/bash

function log_task {
  echo -e "\n------====== $1 ======------"
}

log_task "Cleaning after test"

oc project default
oc delete job generate-traces -n test-generate-traces
oc delete opentelemetrycollector dev
oc delete clusterrolebinding tempostack-traces
oc delete clusterrole tempostack-traces-write
oc delete clusterrolebinding tempostack-traces-reader
oc delete clusterrole tempostack-traces-reader
oc delete tempostack simplest -n test-perfscale
oc delete secret minio -n test-perfscale
oc delete service minio -n test-perfscale
oc delete deployment minio -n test-perfscale
oc delete persistentvolumeclaim minio -n test-perfscale

oc delete project test-perfscale
oc delete project test-generate-traces
oc delete project tutorial-application
