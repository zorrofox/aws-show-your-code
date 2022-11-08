#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-emr-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://emr-eks-spark-${AWS_REGION}-${AWS_ACCOUNT_ID}

aws glue delete-database \
  --region $AWS_REGION \
  --name delta_db

aws glue delete-table \
  --region $AWS_REGION \
  --database-name default \
  --name hudi_table

aws glue delete-table \
  --region $AWS_REGION \
  --database-name default \
  --name iceberg_table

aws s3 rm ${S3blogbucket}/example-prefix \
  --region $AWS_REGION \
  --recursive