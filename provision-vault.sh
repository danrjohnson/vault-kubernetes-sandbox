#! /bin/bash
# Script to set up Vault for Kubernetes testing. Adds relevant auth, policies, and secrets. 
# Requirements: Vault must be unsealed and logged into with the root token 
set -exo pipefail

echo "Writing read-only-policy.hcl"
tee read-only-policy.hcl <<EOF
path "secret/myapp/*" {
    capabilities = ["read", "list"]
}

path "secret/data/*" {
    capabilities = ["read", "list"]
}

path "secret/data/myapp/*" {
    capabilities = ["read", "list"]
}
EOF

echo "Writing read-only-policy to vault" 
vault policy write read-only-policy read-only-policy.hcl

echo "Adding secret to secret/myapp/config"
vault kv put secret/myapp/config username='appuser' password='suP3rsec(et!'

echo "Exporting kubectl environment vars" 
export VAULT_SA_NAME=$(kubectl get sa vault-auth -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=$(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)
export K8S_HOST=$(minikube ip)

echo "Enabling and configuring kubernetes vault auth"
vault auth enable kubernetes
vault write auth/kubernetes/config token_reviewer_jwt="$SA_JWT_TOKEN" kubernetes_host="https://$K8S_HOST:8443" kubernetes_ca_cert="$SA_CA_CRT"

echo "Writing example role to Vault" 
vault write auth/kubernetes/role/example bound_service_account_names=vault-auth bound_service_account_namespaces=default policies=read-only-policy ttl=24h
