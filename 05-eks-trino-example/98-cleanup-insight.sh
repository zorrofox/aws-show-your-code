#! /bin/bash

export CLUSTER_NAME=eks-trino-example
export AWS_REGION=cn-northwest-1

SERVICE_ACCOUNT_NAMESPACE=fargate-container-insights
SERVICE_ACCOUNT_NAME=adot-collector

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
FARGATE_ROLE_IAM_POLICY=arn:aws-cn:iam::${AWS_ACCOUNT_ID}:policy/eks-fargate-logging-policy

kubectl delete -f deploy/fluentbit-fargate.yaml
kubectl delete -f deploy/otel-fargate-container-insights.yaml

eksctl delete iamserviceaccount \
  --cluster=$CLUSTER_NAME \
  --region=$AWS_REGION \
  --name=$SERVICE_ACCOUNT_NAME \
  --namespace=$SERVICE_ACCOUNT_NAMESPACE

kubectl delete ns $SERVICE_ACCOUNT_NAMESPACE

FAGATE_ROLE_NAME=$(aws eks describe-fargate-profile \
  --region $AWS_REGION \
  --cluster $CLUSTER_NAME \
  --fargate-profile-name trino-profile \
  --query 'fargateProfile.podExecutionRoleArn' \
  --output text | cut -d '/' -f 2)

aws iam detach-role-policy \
  --region $AWS_REGION \
  --role-name $FAGATE_ROLE_NAME \
  --policy-arn $FARGATE_ROLE_IAM_POLICY

aws iam delete-policy \
  --region $AWS_REGION \
  --policy-arn $FARGATE_ROLE_IAM_POLICY