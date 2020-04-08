Prerequisites

* Minikube
* cfssl
```
try:
brew install cfssl

if that doesn't work, we can install it a different way...
```

To set everything up the first time, run the scripts in the following order
```
./gencerts
./setup-consul.sh
./setup-vault.sh
. env.sh
./vault-init.sh
```

For every other time you poke with this, just make sure to source the env.sh script or you'll have a bad experience
```
. env.sh
```

Expose consul locally so you can hit it from laptop -> 
```
kubectl port-forward consul-1 8500:8500
```

Then you can view everything using local consul cli
```
$ consul members
Node      Address          Status  Type    Build  Protocol  DC   Segment
consul-0  172.17.0.4:8301  alive   server  1.4.0  2         dc1  <all>
consul-1  172.17.0.5:8301  alive   server  1.4.0  2         dc1  <all>
consul-2  172.17.0.6:8301  alive   server  1.4.0  2         dc1  <all>
```

Get the local vault url for poking around with it and setting it up initially (i.e. set root token)
```
kubectl port-forward $(kubectl get pods | grep vault | awk '{ print $1 }') 8200:8200
```

You can also hit it through the minikube URL (this is how it's done in env.sh)
```
minikube service vault --url | gsed 's/http/https'
```

Most of this was taken from
* https://testdriven.io/blog/running-vault-and-consul-on-kubernetes/
* https://www.vaultproject.io/docs/auth/kubernetes/
* https://learn.hashicorp.com/vault/identity-access-management/vault-agent-k8s
