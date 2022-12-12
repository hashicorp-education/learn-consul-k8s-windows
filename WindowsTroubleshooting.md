# Windows Troubleshooting

## Index

- [About](#about)
- [Datacenter Description](#datacenter-description)
  - [Linux Nodes](#linux-nodes)
  - [Windows Nodes](#windows-nodes)
- [Enabling Windows Support on EKS](#enabling-windows-support-on-eks)
- [Encountered Issues](#encountered-issues)

## About

The purpose of this file is to document the process of deploying a service into a Windows node and registering and managing that service's communication with Consul Service Mesh.

## Datacenter Description

Currently, we are using a mixed setup. Servers and controllers are deployed into Linux nodes while workloads are deployed into Windows nodes.  

### Linux Nodes

As mentioned above, we are deploying into Linux nodes Consul servers and controllers, the pods created by these deployments are listed below:

- Consul Server
- Consul Connect Injector
- Consul Webhook Cert Manager  

### Windows Nodes

On Windows we are deploying the services we want Consul to manage. Each service pod, in addition of the workload container itself, also have the following containers running inside:  

- consul-connect-inject-init: this is an init container. Starts consul-k8s-control-plane with the `connect-init` command.
- consul-dataplane: this is a sidecar container. Runs consul-dataplane, which in turn also runs Envoy.

## Enabling Windows Support on EKS

Amazon EKS clusters must contain one or more Linux or Fargate nodes to run core system pods that only run on Linux, such as CoreDNS, it is recommended to have at least 2 of these nodes.  
When deploying Windows nodes, you **will need to follow the steps described [here](https://docs.aws.amazon.com/eks/latest/userguide/windows-support.html)** to enable Windows support.  

## Encountered Issues

So far we have encountered the following issues:

- Use of `consul.hashicorp.com/connect-inject: true` annotation: this is meant to enable consul-connect-injector to actually inject both the init container. Even though by deploying the injector manually, we can customize the image the injector will use on these "injected" containers, it's not enough to work on Windows. The container it creates use Linux commands, volume mount paths and security context settings that are not valid on Windows.
- `securityContext.privileged: true`: This setting will crash the pod when initializing, since Windows do not support the "privileged" setting. For more information on this subject refer to Kubernetes documentation [here](https://kubernetes.io/docs/concepts/windows/intro/#compatibility-v1-pod-spec-containers).
- None of the pod's securityContext work on Windows. Read more [here](https://kubernetes.io/docs/concepts/windows/intro/#compatibility-v1-pod-spec-containers-securitycontext).
- Volume mount paths: volume mount paths need to be a valid Windows paths.
- Using default configurations, consul-k8s-control-plane can't connect to the consul-server using DNS consul-server.consul.svc because DNS are resolved differently on Windows nodes, you can read more on this topic [here](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/#dns-windows). The workaround we found was **replacing consul-server.consul.svc with just consul-server**.
- Ip Tables is a feature that is not available on Windows. When configuring the **consul-k8s-control-plane** you need to set the Environment variable `CONSUL_REDIRECT_TRAFFIC_CONFIG` to an empty string. Otherwise, the *consul-connect-inject-init* container will fail to start.
- When allocating resources for the consul-connect-inject-init container, allocate more resources, since Windows containers require more memory and CPU than Linux containers.
- Increase values for **terminationGracePeriod** and **tolerations**, since Windows containers need more time to initialize.
