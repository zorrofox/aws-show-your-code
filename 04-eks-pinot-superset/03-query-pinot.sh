#! /bin/bash

if [[ $(nc -z  localhost 9000) != 0 ]]; then
  kubectl port-forward service/pinot-controller 9000:9000 -n pinot > /dev/null &
fi
sleep 10
open http://localhost:9000
# Just for blocking
tail -f /dev/null
pkill -f "kubectl port-forward service/pinot-controller 9000:9000 -n pinot"
