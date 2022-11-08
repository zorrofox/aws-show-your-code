#! /bin/bash

export AWS_REGION=cn-northwest-1
export CLUSTER_NAME=eks-flink-example
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"

export S3blogbucket=s3://flink-eks-${AWS_REGION}-${AWS_ACCOUNT_ID}
export StreamName=ExampleInputStream

aws kinesis create-stream \
  --region $AWS_REGION \
  --stream-name $StreamName

echo "Wait for Kinesis Steam Start..."
aws kinesis wait stream-exists \
  --region $AWS_REGION \
  --stream-name $StreamName

POD=$(kubectl get pod -n flink | grep client | cut -f1 -d ' ')

echo "Copy the Flink JAR to Client Pod..."
kubectl cp resources/aws-kinesis-analytics-java-apps-1.0.jar \
  flink/${POD}:/opt/flink/examples/

echo "Begin execute the Flink JAR and Ctrl-C to exits..."
kubectl exec -n flink deploy/client -- \
  ./bin/flink run -m flink-jobmanager:8081 \
  examples/aws-kinesis-analytics-java-apps-1.0.jar \
  --inputStreamName $StreamName\
  --region $AWS_REGION \
  --s3SinkPath ${S3blogbucket}/output/s3-sink \
  --checkpoint-dir ${S3blogbucket}/checkpoint/

aws s3 sync ${S3blogbucket}/output/s3-sink resources/s3-sink