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
