# Consul Kubernetes on Windows

## About the Project

This repository is the result of a PoC of how to inject Consul into Windows nodes in an EKS cluster. The entry point to our learning guide is [WindowsLearningGuide.md](./WindowsLearningGuide.md).
To read more about the different issues we encountered while working on this PoC refer to our [Windows Troubleshooting](./WindowsTroubleshooting.md) documentation.

## Repository Contents Overview

- k8s-v1.0.x
  - [binaries](k8s-v1.0.x/binaries/): contains the consul-dataplane binary required for the learning guide.
  - [deployments/windows](k8s-v1.0.x/deployments/windows/): deployment YAML files required to deploy services and configure intentions.
  - [dockerfiles](k8s-v1.0.x/dockerfiles/): contains every dockerfile required to build the images used in this learning guide. These images should be uploaded into a registry like Docker hub or AWS ECR. You can find here a description of each file and instructions how to build them.
  - [helm-charts](k8s-v1.0.x/helm-charts/): this directory contains the YAML file with the values to install a Linux cluster using Consul Helm chart. Instructions on how to deploy an AWS EKS cluster can be found here.

## Version Information

|Software           |Version             |Source                                                                           |
|-------------------|--------------------|---------------------------------------------------------------------------------|
|Kubernetes Client  |v1.25.4             |<https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/>                |
|Kubernetes Server  |v1.22.15            |<https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/>                |
|AWS CLI            |v2.7.16             |<https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html>  |
|eksctl             |v0.120.0            |<https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html>                   |
|Helm               |v3.9.2              |<https://helm.sh/docs/intro/install/>                                            |
|Consul Helm Chart  |v1.0.0              |<https://artifacthub.io/packages/helm/hashicorp/consul>                          |
|Consul             |v1.14.0             |<https://releases.hashicorp.com/consul/1.14.0/>                                  |
|Envoy              |v1.24.0             |<https://hub.docker.com/r/envoyproxy/envoy-windows/tags>                         |
|Consul Dataplane   |v1.0.0 custom build | [Binary](k8s-v1.0.x/binaries/)                                                  |
