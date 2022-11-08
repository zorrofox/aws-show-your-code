#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-flink-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://flink-eks-${AWS_REGION}-${AWS_ACCOUNT_ID}

nodegroup=$(aws eks list-nodegroups \
  --region $AWS_REGION \
  --cluster-name $CLUSTER_NAME \
  --query "nodegroups[0]" \
  --output text)

role=$(aws eks describe-nodegroup \
  --region $AWS_REGION \
  --cluster-name $CLUSTER_NAME \
  --nodegroup-name $nodegroup \
  --query "nodegroup.nodeRole" \
  --output text | cut -d '/' -f 2)

aws iam delete-role-policy \
  --role-name $role \
  --policy-name EKS-flink-Containers-Job-Execution

eksctl delete cluster \
  --name $CLUSTER_NAME \
  --region $AWS_REGION

aws s3 rb ${S3blogbucket} --region $AWS_REGION