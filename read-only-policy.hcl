path "secret/myapp/*" {
    capabilities = ["read", "list"]
}

path "secret/data/*" {
    capabilities = ["read", "list"]
}

path "secret/data/myapp/*" {
    capabilities = ["read", "list"]
}
