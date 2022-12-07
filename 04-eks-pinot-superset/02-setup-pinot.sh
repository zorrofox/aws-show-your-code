#! /bin/bash

export CLUSTER_NAME=eks-piont-superset
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

AWS_BUCKET=${CLUSTER_NAME}-${AWS_REGION}-${AWS_ACCOUNT_ID}

aws s3 mb --region $AWS_REGION s3://$AWS_BUCKET

kubectl create ns pinot

eksctl create iamserviceaccount \
    --cluster ${CLUSTER_NAME} \
    --namespace pinot \
    --role-name pinot-${CLUSTER_NAME} \
    --name pinot-sa \
    --override-existing-serviceaccounts \
    --attach-policy-arn "arn:aws-cn:iam::aws:policy/AmazonS3FullAccess" \
    --approve

helm repo add pinot https://raw.githubusercontent.com/apache/pinot/master/kubernetes/helm


cat deploy/pinot-values.yaml | \
  sed -e 's/YOUR-PINOT-BUCKET/'"${AWS_BUCKET}"'/g' \
      -e 's/YOUR-REGION-CODE/'"${AWS_REGION}"'/g' | \
  helm install pinot pinot/pinot -n pinot -f -

helm repo add kafka https://charts.bitnami.com/bitnami
helm install -n pinot kafka kafka/kafka \
  --set replicas=1,zookeeper.image.tag=latest