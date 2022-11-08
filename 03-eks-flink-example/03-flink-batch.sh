#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-flink-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://flink-eks-${AWS_REGION}-${AWS_ACCOUNT_ID}

aws s3 cp resources/kjv.txt \
  ${S3blogbucket}/input/kjv.txt

kubectl exec -n flink deploy/client -- \
  ./bin/flink run -m flink-jobmanager:8081 ./examples/batch/WordCount.jar \
    --input ${S3blogbucket}/input/kjv.txt \
    --output ${S3blogbucket}/output/result

aws s3 cp ${S3blogbucket}/output/result resources/result.txt