#! /bin/bash

export CLUSTER_NAME=eks-emr-example
export AWS_REGION=cn-northwest-1


CLUSTER_ID=$(aws emr-containers list-virtual-clusters \
	--region $AWS_REGION \
	--query "virtualClusters[?state=='RUNNING'].id" --out text)
aws emr-containers delete-virtual-cluster \
  --region $AWS_REGION \
  --id $CLUSTER_ID

aws iam delete-role-policy \
  --region $AWS_REGION \
  --role-name EMRContainers-JobExecutionRole \
  --policy-name EMR-Containers-Job-Execution

aws iam delete-role \
  --region $AWS_REGION \
  --role-name EMRContainers-JobExecutionRole 

eksctl delete cluster \
	--name $CLUSTER_NAME \
	--region $AWS_REGION