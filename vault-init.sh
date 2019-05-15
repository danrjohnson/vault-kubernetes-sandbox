#! /bin/bash
set -exo pipefail

OUTPUT=$(vault operator init -key-shares=1 -key-threshold=1)

echo "$OUTPUT"

echo "saving unseal key to unseal-key.txt"
echo "$OUTPUT" | grep "Unseal Key" > unseal-key.txt

echo "saving initial root token to root-token.txt"
echo "$OUTPUT" | grep " Initial Root Token" > root-token.txt

echo "use the following unseal key to unseal the vault"
cat unseal-key.txt

vault operator unseal

echo "user the following root token to login"
cat root-token.txt
vault login
