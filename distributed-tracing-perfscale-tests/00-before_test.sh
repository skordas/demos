#!/bin/bash

sleep_time=30
r=10 # Number of repeats.

function log_task {
  echo -e "\n------====== $1 ======------"
}

function is_pod_ready {
  ns=$1
  label=$2
  ready=1 #true
  containers=$(oc get pods -n $ns -l $label -o jsonpath={.items[0].status.containerStatuses})
  number_of_elements=$(echo $containers | jq ". | length")
  ((number_of_elements--)) # to get max index
  for i in $(seq 0 $number_of_elements)
  do
    container_name=$(echo $containers | jq -r ".[$i].name")
    container_status=$(echo $containers | jq -r ".[$i].ready")
    if [[ $container_status != true ]]
    then
      ready=0 #false
    fi
  done
  echo $ready
}


### NAMESPACE ###
log_task "CREATING NAMESPACE"
oc create -f ./content/01-namespace.yaml

log_task "CREATING STORAGE"
oc create -f ./content/02-install-storage.yaml
sleep 5
for i in $(seq $r)
do
  status_mino=$(is_pod_ready test-perfscale app.kubernetes.io/name=minio)
  echo "Try #$i/$r Status of:"
  echo "  Minio pod ready: $status_mino"
  if [[ $status_mino == "1" ]]
  then
    echo "Minio is ready"
    break
  else
    if [[ $i == $r ]]
    then
      echo "Minio is not ready after $r attempts!"
      oc get pods -n test-perfscale
      echo "Exiting"
      exit 1
    fi
    echo "Minio is not ready. Waiting for next $sleep_time seconds"
    sleep $sleep_time
  fi
done

log_task "CREATING TEMPOSTACK"
oc create -f ./content/03-tempostack.yaml
sleep 5
for i in $(seq $r)
do
  status_compactor=$(is_pod_ready test-perfscale app.kubernetes.io/component=compactor)
  status_distributor=$(is_pod_ready test-perfscale app.kubernetes.io/component=distributor)
  status_ingester=$(is_pod_ready test-perfscale app.kubernetes.io/component=ingester)
  status_querier=$(is_pod_ready test-perfscale app.kubernetes.io/component=querier)
  status_frontend=$(is_pod_ready test-perfscale app.kubernetes.io/component=query-frontend)
  echo "Try #$i/$r Status of:"
  echo "  Compactor pod ready:   $status_compactor"
  echo "  Distributor pod ready: $status_distributor"
  echo "  Ingester pod ready:    $status_ingester"
  echo "  Querier pod ready:     $status_querier"
  echo "  Frontend pod ready:    $status_frontend"
  if [[ $status_compactor == "1" ]] && [[ $status_distributor == "1" ]] && [[ $status_ingester == "1" ]] && [[ $status_querier == "1" ]] && [[ $status_frontend == "1" ]]
  then
    echo "TempoStack is ready"
    break
  else
    if [[ $i == $r ]]
    then
      echo "TempoStack is not ready after $r attempts!"
      oc get pods -n test-perfscale
      echo "Exiting"
      exit 1
    fi
    echo "TempoStack is not ready. Waiting for next $sleep_time seconds"
    sleep $sleep_time
  fi
done

log_task "Create Cluster Role"
oc create -f ./content/04-cluster-role.yaml

log_task "Create OpenTelemetryCollector"
oc create -f ./content/06-otc.yaml
sleep 10
for i in $(seq $r)
do
  status_mino=$(is_pod_ready test-perfscale app.kubernetes.io/component=opentelemetry-collector)
  echo "Try #$i/$r Status of:"
  echo "  OpenTelemetryCollector pod ready: $status_mino"
  if [[ $status_mino == "1" ]]
  then
    echo "OpenTelemetryCollector is ready"
    break
  else
    if [[ $i == $r ]]
    then
      echo "OpenTelemetryCollector is not ready after $r attempts!"
      oc get pods -n test-perfscale
      echo "Exiting"
      exit 1
    fi
    echo "OpenTelemetryCollector is not ready. Waiting for next $sleep_time seconds"
    sleep $sleep_time
  fi
done

gateway=$(oc get routes -n test-perfscale -o jsonpath={.items[0].spec.host})
echo "https://$gateway/api/traces/v1/dev/search"
