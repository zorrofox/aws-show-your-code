#! /bin/bash

if [[ $(nc -z  localhost 8088) != 0 ]]; then
  kubectl port-forward service/superset 8088:8088 --namespace superset > /dev/null &
fi
sleep 10
open http://localhost:8088
# Just for blocking
tail -f /dev/null
pkill -f "kubectl port-forward service/superset 8088:8088 --namespace superset"
