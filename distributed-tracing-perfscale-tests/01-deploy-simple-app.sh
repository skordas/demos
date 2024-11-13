#!/bin/bash

sleep_time=5
r=12 # sleep_time X r  = final wait time

oc create -f https://raw.githubusercontent.com/pavolloffay/kubecon-eu-2023-opentelemetry-kubernetes-tutorial/main/app/k8s.yaml

for i in $(seq 0 $r); do
  no_of_ready_pods=$(oc get pods -n tutorial-application | grep -c Running)
  if [[ $no_of_ready_pods == 4 ]]; then
    echo "App is ready"
    break
  else
    if [[ $i == $r ]]; then
      echo "App is not ready after $r attempts!"
      oc get pods -n tutorial-application
      echo "Exit"
      exit 1
    fi
    echo "App is not ready. Waiting for next $sleep_time seconds"
    sleep $sleep_time
  fi
done

oc port-forward -n tutorial-application svc/frontend-service 4000:4000
sleep $sleep_time
oc expose service frontend-service -n tutorial-application
sleep $sleep_time
oc get routes -n tutorial-application -o jsonpath={.items[0].spec.host}
sleep $sleep_time
