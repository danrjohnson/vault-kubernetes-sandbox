#export VAULT_ADDR=https://127.0.0.1:8200
export VAULT_ADDR=$(minikube service vault --url | gsed 's/http/https/')
export VAULT_CACERT="certs/ca.pem"
