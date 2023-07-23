[settings.kubernetes]
api-server = "${API_SERVER_URL}"
cluster-certificate = "${B64_CLUSTER_CA}"
cluster-name = "${CLUSTER_NAME}"
cluster-dns-ip = "172.20.0.10"

[settings.kubernetes.node-labels]
"ami" = "bottlerocket"
"env" = "test"
"cluster" = "${CLUSTER_NAME}"
[settings.host-containers.admin]
enabled = true
superpowered = true