#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-emr-example

export KARPENTER_VERSION=v0.16.1
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export AWS_DEFAULT_REGION=$AWS_REGION

echo $KARPENTER_VERSION $CLUSTER_NAME $AWS_DEFAULT_REGION $AWS_ACCOUNT_ID

TEMPOUT=$(mktemp)

curl -fsSL https://karpenter.sh/"${KARPENTER_VERSION}"/getting-started/getting-started-with-eksctl/cloudformation.yaml  > $TEMPOUT \
&& aws cloudformation deploy \
  --stack-name "Karpenter-${CLUSTER_NAME}" \
  --template-file "${TEMPOUT}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides "ClusterName=${CLUSTER_NAME}"

eksctl create iamidentitymapping \
  --username system:node:{{EC2PrivateDNSName}} \
  --cluster "${CLUSTER_NAME}" \
  --arn "arn:aws-cn:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --group system:bootstrappers \
  --group system:nodes


eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --name karpenter --namespace karpenter \
  --role-name "${CLUSTER_NAME}-karpenter" \
  --attach-policy-arn "arn:aws-cn:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}" \
  --role-only \
  --approve

export KARPENTER_IAM_ROLE_ARN="arn:aws-cn:iam::${AWS_ACCOUNT_ID}:role/${CLUSTER_NAME}-karpenter"
export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${CLUSTER_NAME} --query "cluster.endpoint" --output text)"

helm repo add karpenter https://charts.karpenter.sh/
helm repo add eks https://aws.github.io/eks-charts
#helm repo update

helm upgrade --install --namespace karpenter --create-namespace \
  karpenter karpenter/karpenter \
  --version ${KARPENTER_VERSION} \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set clusterName=${CLUSTER_NAME} \
  --set clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${CLUSTER_NAME} \
  --wait # for the defaulting webhook to install before creating a Provisioner


helm upgrade --install --namespace aws-node-termination-handler --create-namespace \
  aws-node-termination-handler eks/aws-node-termination-handler \
    --set enableSpotInterruptionDraining="true" \
    --set enableRebalanceMonitoring="true" \
    --set enableRebalanceDraining="true" \
    --set enableScheduledEventDraining="true" \
    --set nodeSelector."karpenter\.sh/capacity-type"=spot

export NODE_SECURITY_GROUP=$(aws eks describe-cluster --name $CLUSTER_NAME \
    --region $AWS_REGION \
    --query 'cluster.resourcesVpcConfig.securityGroupIds[0]' \
    --output text)

cat <<EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: ondemand
spec:
  ttlSecondsUntilExpired: 2592000 

  ttlSecondsAfterEmpty: 30

  labels:
    karpenter.sh/capacity-type: on-demand

  requirements:
    - key: "kubernetes.io/arch"
      operator: In
      values: ["arm64"]
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["on-demand"]

  limits:
    resources:
      cpu: "1000"
      memory: 1000Gi

  provider: 
    subnetSelector:
      alpha.eksctl.io/cluster-name: $CLUSTER_NAME
    securityGroupSelector:
      alpha.eksctl.io/cluster-name: $CLUSTER_NAME
EOF

cat <<EOF | kubectl apply -f -
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  ttlSecondsUntilExpired: 2592000 

  ttlSecondsAfterEmpty: 30

  labels:
    karpenter.sh/capacity-type: spot

  requirements:
    - key: "kubernetes.io/arch"
      operator: In
      values: ["arm64"]
    - key: "karpenter.sh/capacity-type"
      operator: In
      values: ["spot"]

  limits:
    resources:
      cpu: "1000"
      memory: 1000Gi

  provider: 
    subnetSelector:
      alpha.eksctl.io/cluster-name: $CLUSTER_NAME
    securityGroupSelector:
      alpha.eksctl.io/cluster-name: $CLUSTER_NAME
EOF
