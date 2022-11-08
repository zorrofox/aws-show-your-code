#! /bin/bash

helm uninstall -n superset superset
kubectl delete pvc data-superset-postgresql-0 -n superset
kubectl delete ns superset