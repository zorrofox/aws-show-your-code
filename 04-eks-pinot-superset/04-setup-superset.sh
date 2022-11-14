#! /bin/bash

helm repo add superset https://apache.github.io/superset

kubectl create ns superset
helm upgrade --install --values deploy/superset-values.yaml \
  superset superset/superset -n superset

SUPERSET_POD=$(kubectl get pod -n superset -l app=superset -o name | cut -d '/' -f 2)

kubectl cp dashboard.zip superset/${SUPERSET_POD}:/app/

kubectl exec -n superset deploy/superset -- superset import-dashboards -p dashboard.zip