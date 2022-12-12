# Consul-dataplane for Windows

## General Information

The current binary has been built from source-code based on [PR#46](https://github.com/hashicorp/consul-dataplane/pull/46). And it corresponds to v1.0.0.  

## Testing

- Version: The `consul-dataplane.exe --version` command produces the output below:

```powershell
Consul Dataplane v1.0.0-beta3
Revision
```

- Help: The `consul-dataplane.exe --help` command lists the available commands with a brief description:

```
Usage of consul-dataplane:
    -addresses string
            Consul server gRPC addresses. Value can be:
            1. A DNS name that resolves to server addresses or the DNS name of a load balancer in front of the Consul servers; OR
            2. An executable command in the format, 'exec=<executable with optional args>'. The executable
                    a) on success - should exit 0 and print to stdout whitespace delimited IP (v4/v6) addresses
                    b) on failure - exit with a non-zero code and optionally print an error message of up to 1024 bytes to stderr.
                    Refer to https://github.com/hashicorp/go-netaddrs#summary for more details and examples.
      -ca-certs string
            The path to a file or directory containing CA certificates used to verify the server's certificate.
      -consul-dns-bind-addr string
            The address that will be bound to the consul dns proxy. (default "127.0.0.1")
      -consul-dns-bind-port int
            The port the consul dns proxy will listen on. By default -1 disables the dns proxy (default -1)
      -credential-type string
            The type of credentials, either static or login, used to authenticate with Consul servers.
      -envoy-admin-bind-address string
            The address on which the Envoy admin server is available. (default "127.0.0.1")
      -envoy-admin-bind-port int
            The port on which the Envoy admin server is available. (default 19000)
      -envoy-concurrency int
            The number of worker threads that Envoy uses. (default 2)
      -envoy-ready-bind-address string
            The address on which Envoy's readiness probe is available.
      -envoy-ready-bind-port int
            The port on which Envoy's readiness probe is available.
      -grpc-port int
            The Consul server gRPC port to which consul-dataplane connects. (default 8502)
      -log-json
            Enables log messages in JSON format.
      -log-level string
            Log level of the messages to print. Available log levels are "trace", "debug", "info", "warn", and "error". (default "info")
      -login-auth-method string
            The auth method used to log in.
      -login-bearer-token string
            The bearer token presented to the auth method.
      -login-bearer-token-path string
            The path to a file containing the bearer token presented to the auth method.
      -login-datacenter string
            The datacenter containing the auth method.
      -login-meta value
            A set of key/value pairs to attach to the ACL token. Each pair is formatted as "<key>=<value>". This flag may be passed multiple times.
      -login-namespace string
            The Consul Enterprise namespace containing the auth method.
      -login-partition string
            The Consul Enterprise partition containing the auth method.
      -proxy-service-id string
            The proxy service instance's ID.
      -server-watch-disabled
            Setting this prevents consul-dataplane from consuming the server update stream. This is useful for situations where Consul servers are behind a load balancer.
      -service-namespace string
            The Consul Enterprise namespace in which the proxy service instance is registered.
      -service-node-id string
            The ID of the Consul node to which the proxy service instance is registered.
      -service-node-name string
            The name of the Consul node to which the proxy service instance is registered.
      -service-partition string
            The Consul Enterprise partition in which the proxy service instance is registered.
      -static-token string
            The ACL token used to authenticate requests to Consul servers when -credential-type is set to static.
      -telemetry-prom-ca-certs-path string
            The path to a file or directory containing CA certificates used to verify the Prometheus server's certificate.
      -telemetry-prom-cert-file string
            The path to the client certificate used to serve Prometheus metrics.
      -telemetry-prom-key-file string
            The path to the client private key used to serve Prometheus metrics.
      -telemetry-prom-merge-port int
            The port to serve merged Prometheus metrics. (default 20100)
      -telemetry-prom-retention-time duration
            The duration for Prometheus metrics aggregation. (default 1m0s)
      -telemetry-prom-scrape-path string
            The URL path where Envoy serves Prometheus metrics. (default "/metrics")
      -telemetry-prom-service-metrics-url string
            Prometheus metrics at this URL are scraped and included in Consul Dataplane's main Prometheus metrics.
      -telemetry-use-central-config
      -tls-cert string
            The path to a client certificate file. This is required if tls.grpc.verify_incoming is enabled on the server.
      -tls-disabled
            Communicate with Consul servers over a plaintext connection. Useful for testing, but not recommended for production.
      -tls-insecure-skip-verify
            Do not verify the server's certificate. Useful for testing, but not recommended for production.
      -tls-key string
            The path to a client private key file. This is required if tls.grpc.verify_incoming is enabled on the server.
      -tls-server-name string
            The hostname to expect in the server certificate's subject. This is required if -addresses is not a DNS name.
      -version
            Prints the current version of consul-dataplane.
      -xds-bind-addr string
            The address on which the Envoy xDS server is available. (default "127.0.0.1")
      -xds-bind-port int
            The port on which the Envoy xDS server is available.
```
