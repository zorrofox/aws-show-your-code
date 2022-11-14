#! /bin/bash

helm repo add pinot https://raw.githubusercontent.com/apache/pinot/master/kubernetes/helm
kubectl create ns pinot
helm install pinot pinot/pinot \
    -n pinot \
    --set cluster.name=pinot \
    --set server.replicaCount=3

helm repo add kafka https://charts.bitnami.com/bitnami
helm install -n pinot kafka kafka/kafka \
  --set replicas=1,zookeeper.image.tag=latest

kubectl -n pinot exec kafka-0 \
  -- kafka-topics.sh --bootstrap-server kafka-0:9092 \
     --topic flights-realtime --create --partitions 1 \
     --replication-factor 1
kubectl -n pinot exec kafka-0 \
  -- kafka-topics.sh --bootstrap-server kafka-0:9092 \
     --topic flights-realtime-avro --create --partitions 1 \
     --replication-factor 1

kubectl apply -f deploy/pinot-realtime-quickstart.yml