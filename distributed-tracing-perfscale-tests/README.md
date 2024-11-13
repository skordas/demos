# Distributed Tracing - PerfScale tests results

Google slide [presentation](https://docs.google.com/presentation/d/13y0xBNAnw5QvRII3fGQAHEIieLeJHIWDACgKtH1D8lM/edit#slide=id.g547716335e_0_235)

## Test environment preparation.

Operator pods should be running on additional `infra` node.
You can use one CR to create one using one of provided files.

- Get name of your cluster:

```bash
oc get -o jsonpath='{.status.infrastructureName}{"\n"}' infrastructure cluster
```
- Use template file for [AWS](./content/infra_node_AWS.yaml) or [GCP](./content/infra_node_GCP.yaml) then find and replace the value `${CLUSTER_NAME}` with name of your cluster.

- Create infra node:

```bash
oc create -f path_to_my_infra_node.yaml
```

- Install dittybopper dashboard:

```bash
git clone https://github.com/cloud-bulldozer/performance-dashboards.git
cd performance-dashboards/dittybopper
./deploy.sh
cd ../..
rm -rf performance-dashboards
```

- Log into console and install operators
    - Operators -> OperatorHub -> Tempo Operator
    - Operators -> OperatorHub -> Red Hat build of OpenTelemetry

- Run `./00-before_test.sh` to prepare TempoStack and OpenTelemetryColector

## Generate traces

- Run `./01-generate_traces.sh` to generate traces.

## Cleanup

- To cleanup after test run `./02-after_test_cleaning.sh`
