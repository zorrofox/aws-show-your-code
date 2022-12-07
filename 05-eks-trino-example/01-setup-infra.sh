#! /bin/bash

export CLUSTER_NAME=eks-trino-example
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

eksctl create cluster \
  --name $CLUSTER_NAME \
  --region $AWS_REGION \
  --without-nodegroup \
  --with-oidc

eksctl create fargateprofile \
  --cluster $CLUSTER_NAME \
  --name kubesystem-profile \
  --namespace kube-system

eksctl create fargateprofile \
  --cluster $CLUSTER_NAME \
  --name trino-profile \
  --namespace trino

eksctl create fargateprofile \
  --cluster $CLUSTER_NAME \
  --name insight-profile \
  --namespace fargate-container-insights