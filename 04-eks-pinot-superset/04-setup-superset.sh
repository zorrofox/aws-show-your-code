#! /bin/bash

helm repo add superset https://apache.github.io/superset

kubectl create ns superset
helm upgrade --install --values deploy/superset-values.yaml \
  superset superset/superset -n superset