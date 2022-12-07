#! /bin/bash

helm uninstall -n trino example-trino 
kubectl delete ns trino

AWS_ACCESS_ID=$(cat resources/.key)

aws iam delete-access-key --access-key-id $AWS_ACCESS_ID
rm resources/.key