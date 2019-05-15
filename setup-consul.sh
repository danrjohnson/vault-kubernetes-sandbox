#! /bin/bash
set -exo pipefail


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
