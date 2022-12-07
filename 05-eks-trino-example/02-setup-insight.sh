##!/bin/bash

export CLUSTER_NAME=eks-trino-example
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

SERVICE_ACCOUNT_NAMESPACE=fargate-container-insights
SERVICE_ACCOUNT_NAME=adot-collector
SERVICE_ACCOUNT_IAM_ROLE=EKS-Fargate-ADOT-ServiceAccount-Role
SERVICE_ACCOUNT_IAM_POLICY=arn:aws-cn:iam::aws:policy/CloudWatchAgentServerPolicy

aws iam create-policy \
  --policy-name eks-fargate-logging-policy \
  --policy-document file://resources/logging-permissions.json

FARGATE_ROLE_IAM_POLICY=arn:aws-cn:iam::${AWS_ACCOUNT_ID}:policy/eks-fargate-logging-policy

FAGATE_ROLE_NAME=$(aws eks describe-fargate-profile \
  --region $AWS_REGION \
  --cluster $CLUSTER_NAME \
  --fargate-profile-name trino-profile \
  --query 'fargateProfile.podExecutionRoleArn' \
  --output text | cut -d '/' -f 2)

aws iam attach-role-policy \
  --region $AWS_REGION \
  --role-name $FAGATE_ROLE_NAME \
  --policy-arn $FARGATE_ROLE_IAM_POLICY

kubectl create ns $SERVICE_ACCOUNT_NAMESPACE

eksctl create iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --region=$AWS_REGION \
  --name=$SERVICE_ACCOUNT_NAME \
  --namespace=$SERVICE_ACCOUNT_NAMESPACE \
  --role-name=$SERVICE_ACCOUNT_IAM_ROLE \
  --attach-policy-arn=$SERVICE_ACCOUNT_IAM_POLICY \
  --approve


cat deploy/otel-fargate-container-insights.yaml | \
  sed -e 's/YOUR-CLUSTER-NAME/'"${CLUSTER_NAME}"'/g' \
      -e 's/YOUR-REGION-CODE/'"${AWS_REGION}"'/g' | \
kubectl apply -f -

kubectl apply -f deploy/fluentbit-fargate.yaml