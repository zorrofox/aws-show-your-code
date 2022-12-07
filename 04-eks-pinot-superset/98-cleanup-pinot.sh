#! /bin/bash

export CLUSTER_NAME=eks-piont-superset
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

AWS_BUCKET=${CLUSTER_NAME}-${AWS_REGION}-${AWS_ACCOUNT_ID}

helm uninstall -n pinot kafka
helm uninstall -n pinot pinot

for p in $(kubectl get pvc -n pinot -o name)
do
	kubectl delete -n pinot $p
done

eksctl delete iamserviceaccount \
    --cluster ${CLUSTER_NAME} \
    --namespace pinot \
    --name pinot-sa

kubectl delete ns pinot

aws s3 rm s3://${AWS_BUCKET}/ \
  --region $AWS_REGION \
  --recursive

aws s3 rb --region $AWS_REGION s3://${AWS_BUCKET}