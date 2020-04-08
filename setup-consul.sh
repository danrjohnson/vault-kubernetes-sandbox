#! /bin/bash
set -exo pipefail

if [ $(kubectl config view -o json  | jq '.["current-context"]') != '"minikube"' ]; then
    echo 'k8s context is NOT minikube.  this is probably not what you want'
    echo 'run `kubectl config use-context minikube`'
    echo 'if THAT does not work, look at the value of your KUBECONFIG enviornment variable'
    exit 1
else
    echo 'Using correct k8s context...'
fi

if [ -z "$GOSSIP_ENCRYPTION_KEY" ]; then
	export GOSSIP_ENCRYPTION_KEY=$(consul keygen)
	
	kubectl create secret generic consul \
	  --from-literal="gossip-encryption-key=${GOSSIP_ENCRYPTION_KEY}" \
	  --from-file=certs/ca.pem \
	  --from-file=certs/consul.pem \
	  --from-file=certs/consul-key.pem
	
	kubectl describe secrets consul
fi

kubectl create configmap consul --from-file=consul/config.json

kubectl describe configmap consul

kubectl create -f consul/service.yaml

kubectl create -f consul/statefulset.yaml
