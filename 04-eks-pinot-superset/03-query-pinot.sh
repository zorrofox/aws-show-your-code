#! /bin/bash

export CLUSTER_NAME=eks-piont-superset
export AWS_REGION=cn-northwest-1

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

AWS_BUCKET=${CLUSTER_NAME}-${AWS_REGION}-${AWS_ACCOUNT_ID}

aws s3 cp --region $AWS_REGION \
  resources/billing_data.csv \
  s3://${AWS_BUCKET}/pinot-ingestion/batch-input/billing_data.csv

cat deploy/pinot-batch-quickstart.yaml | \
  sed -e 's/YOUR-PINOT-BUCKET/'"${AWS_BUCKET}"'/g' \
      -e 's/YOUR-REGION-CODE/'"${AWS_REGION}"'/g' | \
  kubectl apply -f - 

kubectl -n pinot exec kafka-0 \
  -- kafka-topics.sh --bootstrap-server kafka-0:9092 \
     --topic flights-realtime --create --partitions 1 \
     --replication-factor 1
kubectl -n pinot exec kafka-0 \
  -- kafka-topics.sh --bootstrap-server kafka-0:9092 \
     --topic flights-realtime-avro --create --partitions 1 \
     --replication-factor 1

kubectl apply -f deploy/pinot-realtime-quickstart.yml

if [[ $(nc -z  localhost 9000) != 0 ]]; then
  kubectl port-forward service/pinot-controller 9000:9000 -n pinot > /dev/null &
fi
sleep 10
open http://localhost:9000
# Just for blocking
tail -f /dev/null
pkill -f "kubectl port-forward service/pinot-controller 9000:9000 -n pinot"
