#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-emr-example

export KARPENTER_VERSION=v0.16.1
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export AWS_DEFAULT_REGION=$AWS_REGION
echo $KARPENTER_VERSION $CLUSTER_NAME $AWS_DEFAULT_REGION $AWS_ACCOUNT_ID

eksctl delete iamserviceaccount \
  --region=$AWS_REGION \
  --cluster=$CLUSTER_NAME \
  --namespace=karpenter \
  --name=karpenter

helm uninstall karpenter --namespace karpenter
aws cloudformation delete-stack --stack-name "Karpenter-${CLUSTER_NAME}"
aws ec2 describe-launch-templates \
    | jq -r ".LaunchTemplates[].LaunchTemplateName" \
    | grep -i "Karpenter-${CLUSTER_NAME}" \
    | xargs -I{} aws ec2 delete-launch-template --launch-template-name {}
