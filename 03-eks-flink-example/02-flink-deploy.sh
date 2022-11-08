#! /bin/bash

export CLUSTER_NAME=eks-flink-example
export AWS_REGION=cn-northwest-1

kubectl create namespace flink

kubectl create clusterrolebinding \
  flink-role-binding-default \
  --clusterrole=edit \
  --serviceaccount=default:default

kubectl create serviceaccount flink-service-account -n flink

kubectl create clusterrolebinding flink-role-binding-flink \
  --clusterrole=edit \
  --serviceaccount=default:flink-service-account

for f in $(ls deploy/*.yaml)
do
	kubectl apply -n flink -f ${f}
done
