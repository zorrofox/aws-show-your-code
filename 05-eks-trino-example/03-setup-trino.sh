#! /bin/bash

export CLUSTER_NAME=eks-trino-example
export AWS_REGION=cn-northwest-1

AWS_IAM_USER=$(aws sts get-caller-identity \
  --query Arn \
  --output text | cut -d '/' -f 2)

i=0
for o in $(aws iam create-access-key \
  --user-name $AWS_IAM_USER \
  --query "AccessKey" \
  --output text)
do
  let "i=i+1"
  if [ $i -eq 1 ] 
  then
    AWS_ACCESS_ID=$o
  fi
  if [ $i -eq 3 ] 
  then
    AWS_SECRET_ID=$o
  fi
done

echo $AWS_ACCESS_ID >> resources/.key

kubectl create ns trino

helm repo add trino https://trinodb.github.io/charts
cat deploy/trino-values.yaml | \
  sed -e 's/YOUR-AWS-ACCESS-KEY/'"${AWS_ACCESS_ID}"'/g' \
      -e 's/YOUR-AWS-SECRET-KEY/'"${AWS_SECRET_ID}"'/g' \
      -e 's/YOUR-REGION-CODE/'"${AWS_REGION}"'/g' | \
helm install -n trino example-trino trino/trino -f -