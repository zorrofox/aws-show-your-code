#! /bin/bash

export CLUSTER_NAME=eks-trino-example
export AWS_REGION=cn-northwest-1

eksctl delete cluster \
  --region $AWS_REGION \
  --name $CLUSTER_NAME