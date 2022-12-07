#! /bin/bash

export CLUSTER_NAME=eks-piont-superset
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

eksctl create cluster \
--name $CLUSTER_NAME \
--region $AWS_REGION \
--node-type m5.xlarge \
--nodes 5 \
--nodes-max 5 \
--with-oidc

eksctl create addon \
  --cluster ${CLUSTER_NAME} \
  --name aws-ebs-csi-driver \
  --attach-policy-arn arn:aws-cn:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy