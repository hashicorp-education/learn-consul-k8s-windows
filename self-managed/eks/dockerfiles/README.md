# Docker Images Required to Run Consul on Windows Kubernetes Nodes

## Index

- [About](#about)
- [Docker Images](#docker-images)
  - [Windows Version](#windows-version)
  - [Windows Consul Image](#windows-consul-image)
  - [Windows consul-k8s-control-plane Image](#windows-consul-k8s-control-plane-image)
  - [Windows consul-dataplane Image](#windows-consul-dataplane-image)  

## About

The purpose of this file is to describe the 3 main images used to deploy Consul on Windows Kubernetes nodes.

## Docker Images

As a general consideration, when creating the Windows images required to deploy Consul Kubernetes on Windows nodes, we used the same Windows distribution as the one we use on our nodes to avoid any incompatibility issues. Also, many of the commands used on the deployment objects are passed in Linux syntax, in order to be able to use them without the need of extensive modifications we installed Git Bash on our images, and set it as a default shell.

### Windows Version

For all of our Docker images we used **mcr.microsoft.com/windows/servercore:1809** image as base image.

### Windows Consul Image

This image provides the the Consul version for Windows. This is built on top of the official [Windows server core](https://hub.docker.com/_/microsoft-windows-servercore) as base and the Consul binary is downloaded from HashiCorp's official releases (<https://www.consul.io/downloads>). Finally this executable is set as default entrypoint.
To build the image run the following command:

```bash
docker build -t docker.mirror.hashicorp.services/windows/consul -f Dockerfile-consul-windows .
```

You can test the built image by running the following command:

```bash
docker run --name consul-windows docker.mirror.hashicorp.services/windows/consul
```

### Windows consul-k8s-control-plane Image

This image provides the consul-k8s-control-plane version for Windows. As mentioned before it is algo built on top of the official [Windows server core](https://hub.docker.com/_/microsoft-windows-servercore) as base and the consul-k8s-control-plane binary downloaded from HashiCorp's official releases webpage (<https://releases.hashicorp.com/consul-k8s-control-plane/>). Finally this executable is set as default entrypoint.  
To build the image run the following command:

```bash
docker build -t docker.mirror.hashicorp.services/windows/consul-k8s-control-plane -f Dockerfile-consul-k8s-control-plane-windows .
```

You can test the built image by running the following command:

```bash
docker run --name consul-k8s-control-plane docker.mirror.hashicorp.services/windows/consul-k8s-control-plane
```

The container will return the following response:

```bash
Usage: consul-k8s [--version] [--help] <command> [<args>]

Available commands are:
    acl-init                          Initialize ACLs on non-server components.
    connect-init                      Inject connect init command.
    consul-logout                     Issue a consul logout to delete the ACL token.
    consul-sidecar                    Consul sidecar for Connect.
    controller                        Starts the Consul Kubernetes controller
    webhook-cert-manager              Starts the Consul Kubernetes webhook-cert-manager
```

### Windows consul-dataplane Image

This image provides the consul-dataplane version for Windows. As mentioned before it is algo built on top of the official [Windows server core](https://hub.docker.com/_/microsoft-windows-servercore) as base, the Windows Envoy binary copied from Envoy's official Windows Docker image, finally, the consul-dataplane binary has been built locally with custom source code to enable Windows integration, then copied into the image. The binary available in this repo has been built using [these changes](https://github.com/hashicorp/consul-dataplane/pull/46) as base.  
To build this image use the available script:

```bash
sh build-dockerfile-consul-dataplane-envoy-windows.sh
```

You can test the built image by running the following command:

```bash
docker run --name consul-dataplane docker.mirror.hashicorp.services/windows/consul-dataplane-envoy-windows:latest -help
```

The container will return the following response:

```
    -addresses string
            Consul server gRPC addresses. Value can be:
            1. A DNS name that resolves to server addresses or the DNS name of a load balancer in front of the Consul servers; OR
            2. An executable command in the format, 'exec=<executable with optional args>'. The executable
                    a) on success - should exit 0 and print to stdout whitespace delimited IP (v4/v6) addresses
                    b) on failure - exit with a non-zero code and optionally print an error message of up to 1024 bytes to stderr.
                    Refer to https://github.com/hashicorp/go-netaddrs#summary for more details and examples.
             Environment variable: DP_CONSUL_ADDRESSES.
      -ca-certs string
            The path to a file or directory containing CA certificates used to verify the server's certificate. Environment variable: DP_CA_CERTS.        
      -consul-dns-bind-addr string
            The address that will be bound to the consul dns proxy. Environment variable: DP_CONSUL_DNS_BIND_ADDR. (default "127.0.0.1")
      -consul-dns-bind-port int
            The port the consul dns proxy will listen on. By default -1 disables the dns proxy Environment variable: DP_CONSUL_DNS_BIND_PORT. (default -1)
      -credential-type string
            The type of credentials, either static or login, used to authenticate with Consul servers. Environment variable: DP_CREDENTIAL_TYPE.
      -envoy-admin-bind-address string
            The address on which the Envoy admin server is available. Environment variable: DP_ENVOY_ADMIN_BIND_ADDRESS. (default "127.0.0.1")
      -envoy-admin-bind-port int
            The port on which the Envoy admin server is available. Environment variable: DP_ENVOY_ADMIN_BIND_PORT. (default 19000)
      -envoy-concurrency int
            The number of worker threads that Envoy uses. Environment variable: DP_ENVOY_CONCURRENCY. (default 2)
      -envoy-ready-bind-address string
            The address on which Envoy's readiness probe is available. Environment variable: DP_ENVOY_READY_BIND_ADDRESS.
      -envoy-ready-bind-port int
            The port on which Envoy's readiness probe is available. Environment variable: DP_ENVOY_READY_BIND_PORT.
      -grpc-port int
            The Consul server gRPC port to which consul-dataplane connects. Environment variable: DP_CONSUL_GRPC_PORT. (default 8502)
      -log-json
            Enables log messages in JSON format. Environment variable: DP_LOG_JSON.
      -log-level string
            Log level of the messages to print. Available log levels are "trace", "debug", "info", "warn", and "error". Environment variable: DP_LOG_LEVEL. (default "info")    
      -login-auth-method string
            The auth method used to log in. Environment variable: DP_CREDENTIAL_LOGIN_AUTH_METHOD.
      -login-bearer-token string
            The bearer token presented to the auth method. Environment variable: DP_CREDENTIAL_LOGIN_BEARER_TOKEN.
      -login-bearer-token-path string
            The path to a file containing the bearer token presented to the auth method. Environment variable: DP_CREDENTIAL_LOGIN_BEARER_TOKEN_PATH.
      -login-datacenter string
            The datacenter containing the auth method. Environment variable: DP_CREDENTIAL_LOGIN_DATACENTER.
      -login-meta value
            A set of key/value pairs to attach to the ACL token. Each pair is formatted as "<key>=<value>". This flag may be passed multiple times. Environment variable: DP_CREDENTIAL_LOGIN_META{1,9}.
      -login-namespace string
            The Consul Enterprise namespace containing the auth method. Environment variable: DP_CREDENTIAL_LOGIN_NAMESPACE.
      -login-partition string
            The Consul Enterprise partition containing the auth method. Environment variable: DP_CREDENTIAL_LOGIN_PARTITION.
      -proxy-service-id string
            The proxy service instance's ID. Environment variable: DP_PROXY_SERVICE_ID.
      -proxy-service-id-path string
            The path to a file containing the proxy service instance's ID. Environment variable: DP_PROXY_SERVICE_ID_PATH.
      -server-watch-disabled
            Setting this prevents consul-dataplane from consuming the server update stream. This is useful for situations where Consul servers are behind a load balancer. Environment variable: DP_SERVER_WATCH_DISABLED.
      -service-namespace string
            The Consul Enterprise namespace in which the proxy service instance is registered. Environment variable: DP_SERVICE_NAMESPACE.
      -service-node-id string
            The ID of the Consul node to which the proxy service instance is registered. Environment variable: DP_SERVICE_NODE_ID.
      -service-node-name string
            The name of the Consul node to which the proxy service instance is registered. Environment variable: DP_SERVICE_NODE_NAME.
      -service-partition string
            The Consul Enterprise partition in which the proxy service instance is registered. Environment variable: DP_SERVICE_PARTITION.
      -static-token string
            The ACL token used to authenticate requests to Consul servers when -credential-type is set to static. Environment variable: DP_CREDENTIAL_STATIC_TOKEN.
      -telemetry-prom-ca-certs-path string
            The path to a file or directory containing CA certificates used to verify the Prometheus server's certificate. Environment variable: DP_TELEMETRY_PROM_CA_CERTS_PATH.
      -telemetry-prom-cert-file string
            The path to the client certificate used to serve Prometheus metrics. Environment variable: DP_TELEMETRY_PROM_CERT_FILE.
      -telemetry-prom-key-file string
            The path to the client private key used to serve Prometheus metrics. Environment variable: DP_TELEMETRY_PROM_KEY_FILE.
      -telemetry-prom-merge-port int
            The port to serve merged Prometheus metrics. Environment variable: DP_TELEMETRY_PROM_MERGE_PORT. (default 20100)
      -telemetry-prom-retention-time duration
            The duration for prometheus metrics aggregation. Environment variable: DP_TELEMETRY_PROM_RETENTION_TIME. (default 1m0s)
      -telemetry-prom-scrape-path string
            The URL path where Envoy serves Prometheus metrics. Environment variable: DP_TELEMETRY_PROM_SCRAPE_PATH. (default "/metrics")
      -telemetry-prom-service-metrics-url string
      -telemetry-use-central-config
            Controls whether the proxy applies the central telemetry configuration. Environment variable: DP_TELEMETRY_USE_CENTRAL_CONFIG. (default true)
      -tls-cert string
            The path to a client certificate file. This is required if tls.grpc.verify_incoming is enabled on the server. Environment variable: DP_TLS_CERT.
      -tls-disabled
            Communicate with Consul servers over a plaintext connection. Useful for testing, but not recommended for production. Environment variable: DP_TLS_DISABLED.
      -tls-insecure-skip-verify
            Do not verify the server's certificate. Useful for testing, but not recommended for production. Environment variable: DP_TLS_INSECURE_SKIP_VERIFY.
      -tls-key string
            The path to a client private key file. This is required if tls.grpc.verify_incoming is enabled on the server. Environment variable: DP_TLS_KEY.
      -tls-server-name string
            The hostname to expect in the server certificate's subject. This is required if -addresses is not a DNS name. Environment variable: DP_TLS_SERVER_NAME.
      -version
            Prints the current version of consul-dataplane.
      -xds-bind-addr string
            The address on which the Envoy xDS server is available. Environment variable: DP_XDS_BIND_ADDR. (default "127.0.0.1")
      -xds-bind-port int
            The port on which the Envoy xDS server is available. Environment variable: DP_XDS_BIND_PORT.
```
