#! /bin/bash

export CLUSTER_NAME=eks-piont-superset
export AWS_REGION=cn-northwest-1

eksctl create cluster \
--name $CLUSTER_NAME \
--region $AWS_REGION \
--node-type m5.xlarge \
--nodes 5 \
--nodes-max 5 \
--with-oidc