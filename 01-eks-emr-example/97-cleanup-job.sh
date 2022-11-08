#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-emr-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://emr-eks-spark-${AWS_REGION}-${AWS_ACCOUNT_ID}

aws s3 rm ${S3blogbucket}/ \
  --region $AWS_REGION \
  --recursive

aws s3 rb ${S3blogbucket} --region $AWS_REGION