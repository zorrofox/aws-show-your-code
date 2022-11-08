#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-flink-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://flink-eks-${AWS_REGION}-${AWS_ACCOUNT_ID}
export StreamName=ExampleInputStream

aws s3 rm ${S3blogbucket}/ \
  --region $AWS_REGION \
  --recursive

rm -fr resources/s3-sink
rm -fr resources/result.txt

aws kinesis delete-stream \
  --region $AWS_REGION \
  --stream-name $StreamName