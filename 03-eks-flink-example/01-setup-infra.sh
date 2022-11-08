#! /bin/bash

export CLUSTER_NAME=eks-flink-example
export AWS_REGION=cn-northwest-1

eksctl create cluster \
--name $CLUSTER_NAME \
--region $AWS_REGION \
--node-type m6g.xlarge \
--nodes 3 \
--nodes-max 5 \
--with-oidc

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

TEMPOUT=$(mktemp)

cat <<EoF > $TEMPOUT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:ListBucket",
              "s3:DeleteObject"
            ],
            "Resource": "arn:aws-cn:s3:::flink-eks-*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:ListStreams",
                "kinesis:EnableEnhancedMonitoring",
                "kinesis:ListShards",
                "kinesis:UpdateShardCount",
                "kinesis:DescribeLimits",
                "kinesis:ListStreamConsumers",
                "kinesis:DisableEnhancedMonitoring",
                "kinesis:GetShardIterator",
                "kinesis:GetRecords"
            ],
            "Resource": "*"
        }
    ]
}  
EoF

aws iam put-role-policy \
  --region $AWS_REGION \
  --role-name $role \
  --policy-name EKS-flink-Containers-Job-Execution \
  --policy-document file://${TEMPOUT}

export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export S3blogbucket=s3://flink-eks-${AWS_REGION}-${AWS_ACCOUNT_ID}
aws s3 mb $S3blogbucket --region $AWS_REGION
