#! /bin/bash

export CLUSTER_NAME=eks-emr-example
export AWS_REGION=cn-northwest-1

eksctl create cluster \
--name $CLUSTER_NAME \
--region $AWS_REGION \
--node-type m6g.xlarge \
--with-oidc

kubectl create namespace emr


eksctl create iamidentitymapping \
    --cluster $CLUSTER_NAME \
    --namespace emr \
    --service-name "emr-containers"

namespace=emr

cat - <<EOF | kubectl apply -f - --namespace "${namespace}"
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: emr-containers
  namespace: ${namespace}
rules:
  - apiGroups: [""]
    resources: ["namespaces"]
    verbs: ["get"]
  - apiGroups: [""]
    resources: ["serviceaccounts", "services", "configmaps", "events", "pods", "pods/log"]
    verbs: ["get", "list", "watch", "describe", "create", "edit", "delete", "deletecollection", "annotate", "patch", "label"]
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["create", "patch", "delete", "watch"]
  - apiGroups: ["apps"]
    resources: ["statefulsets", "deployments"]
    verbs: ["get", "list", "watch", "describe", "create", "edit", "delete", "annotate", "patch", "label"]
  - apiGroups: ["batch"]
    resources: ["jobs"]
    verbs: ["get", "list", "watch", "describe", "create", "edit", "delete", "annotate", "patch", "label"]
  - apiGroups: ["extensions"]
    resources: ["ingresses"]
    verbs: ["get", "list", "watch", "describe", "create", "edit", "delete", "annotate", "patch", "label"]
  - apiGroups: ["rbac.authorization.k8s.io"]
    resources: ["roles", "rolebindings"]
    verbs: ["get", "list", "watch", "describe", "create", "edit", "delete", "deletecollection", "annotate", "patch", "label"]
EOF


cat - <<EOF | kubectl apply -f - --namespace "${namespace}"
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: emr-containers
  namespace: ${namespace}
subjects:
- kind: User
  name: emr-containers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: emr-containers
  apiGroup: rbac.authorization.k8s.io
EOF

AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

eksctl create iamidentitymapping \
    --region $AWS_REGION \
    --cluster $CLUSTER_NAME \
    --arn "arn:aws-cn:iam::${AWS_ACCOUNT_ID}:role/AWSServiceRoleForAmazonEMRContainers" \
    --username emr-containers

eksctl utils associate-iam-oidc-provider --cluster $CLUSTER_NAME --approve

TEMPOUT=$(mktemp)

cat <<EoF > $TEMPOUT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EoF

aws iam create-role \
  --region $AWS_REGION \
  --role-name EMRContainers-JobExecutionRole \
  --assume-role-policy-document file://${TEMPOUT}

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
            "Resource": "arn:aws-cn:s3:::emr-eks-spark*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "logs:PutLogEvents",
              "logs:CreateLogStream",
              "logs:DescribeLogGroups",
              "logs:DescribeLogStreams",
              "logs:CreateLogGroup"
            ],
            "Resource": "arn:aws-cn:logs:${AWS_REGION}:${AWS_ACCOUNT_ID}:*"
        },
        {
          "Effect": "Allow",
          "Action": [
            "glue:Get*",
            "glue:BatchCreatePartition",
            "glue:UpdateTable",
            "glue:CreateTable",
            "glue:CreateDatabase",
            "glue:DeleteTable"
          ],
          "Resource": [
            "arn:aws-cn:glue:${AWS_REGION}:${AWS_ACCOUNT_ID}:catalog",
            "arn:aws-cn:glue:${AWS_REGION}:${AWS_ACCOUNT_ID}:database/*",
            "arn:aws-cn:glue:${AWS_REGION}:${AWS_ACCOUNT_ID}:table/*"
          ]
        },
        {
            "Sid": "DynamoDBLockManager",
            "Effect": "Allow",
            "Action": [
              "dynamodb:DescribeTable",
              "dynamodb:CreateTable",
              "dynamodb:Query",
              "dynamodb:Scan",
              "dynamodb:PutItem",
              "dynamodb:UpdateItem",
              "dynamodb:DeleteItem",
              "dynamodb:BatchWriteItem",
              "dynamodb:GetItem",
              "dynamodb:BatchGetItem"
            ],
            "Resource": [
              "arn:aws-cn:dynamodb:${AWS_REGION}:${AWS_ACCOUNT_ID}:table/myIcebergLockTable",
              "arn:aws-cn:dynamodb:${AWS_REGION}:${AWS_ACCOUNT_ID}:table/myIcebergLockTable/index/*",
              "arn:aws-cn:dynamodb:${AWS_REGION}:${AWS_ACCOUNT_ID}:table/myHudiLockTable"
            ]
        }
    ]
}  
EoF
aws iam put-role-policy \
  --region $AWS_REGION \
  --role-name EMRContainers-JobExecutionRole \
  --policy-name EMR-Containers-Job-Execution \
  --policy-document file://${TEMPOUT}

aws emr-containers update-role-trust-policy \
  --region $AWS_REGION \
  --cluster-name $CLUSTER_NAME \
  --namespace $namespace \
  --role-name EMRContainers-JobExecutionRole

aws emr-containers create-virtual-cluster \
	--name virtual-$CLUSTER_NAME \
	--container-provider '{
	    "id": "'${CLUSTER_NAME}'",
	    "type": "EKS",
	    "info": {
	        "eksInfo": {
	            "namespace": "'${namespace}'"
	        }
	    }
	}'

