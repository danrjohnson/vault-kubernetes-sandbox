#! /bin/bash
set -exo pipefail

kubectl create secret generic vault \
    --from-file=certs/ca.pem \
    --from-file=certs/vault.pem \
    --from-file=certs/vault-key.pem


kubectl create configmap vault --from-file=vault/config.json

kubectl describe configmap vault

kubectl create -f vault/service.yaml

kubectl get service vault

kubectl apply -f vault/deployment.yaml

kubectl get pods
