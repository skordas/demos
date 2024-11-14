#!/bin/bash

wait=30
r=20

function log_task {
  echo -e "\n------====== $1 ======------"
}

log_task "GENERATING TRACES"
oc create -f ./content/07-generate-traces.yaml

for i in $(seq $r)
do
  completed=$(oc get jobs -n test-generate-traces | grep -c Complete)
  if [[ $completed == "1" ]]
  then
    echo "Traces are generated!"
    break
  else
    if [[ $i == $r ]]
    then
      echo "Something is wrong with trace generator after $r attempts"
      oc get jobs -n test-generate-traces
      oc get pods -n test-generate-traces
      echo "EXIT"
      exit 1
    fi
    echo "Job still running. Waiting for next $wait seconds"
    sleep $wait
  fi
done
