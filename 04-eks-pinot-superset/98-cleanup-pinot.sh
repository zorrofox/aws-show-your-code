#! /bin/bash

helm uninstall -n pinot kafka
helm uninstall -n pinot pinot

for p in $(kubectl get pvc -n pinot -o name)
do
	kubectl delete -n pinot $p
done

kubectl delete ns pinot