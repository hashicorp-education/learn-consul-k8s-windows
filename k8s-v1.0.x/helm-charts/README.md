# Deploy Consul cluster with Helm Chart on EKS on Linux Nodes

## Index

- [About this Guide](#about-this-guide)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)

## About this Guide

This guide is intended for learning purposes only and should not be used for production. This guide will walk you through the different steps required to deploy on AWS EKS cluster, the Consul server via Helm chart in Linux nodes.

### Prerequisites

In order to deploy the EKS cluster and all the necessary resources, you need to have configured/installed next tools:

- [AWS account](https://aws.amazon.com/account/) with the necessary privileges to create and delete resources.
  - [EKS role and permission polices](https://docs.aws.amazon.com/eks/latest/userguide/security-iam.html#security_iam_access-manage)
- Install [Docker](https://docs.docker.com/get-docker/)
- Install [AWS cli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Install [K8s cli](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/)
- Install [Helm](https://helm.sh/docs/intro/install/)
- Install [Eksctl cli](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
  - Configure [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-config)

## Getting Started

Once configured the AWS account, next steps/commands will allow you create the EKS cluster with Linux nodes by default, enable support for Windows nodes and create them and finally install the Consul server and client on them. For that, open and Powershell/Bash terminal and enter the following commands to ease the understanding and execution of the commands used during the guide

1. Set common local variables. If you want, you can modify the set region and/or cluster name

   ```bash
   AWS_REGION=us-east-1
   CLUSTER_NAME=consul-cluster
   KEY_PAIR_NAME=consul-key-pair
   INSTANCE_TYPE=t3.medium
   WINDOWS_AMI_FAMILY=WindowsServer2019CoreContainer
   ```

1. Create AWS key pair. This command will show you the private key that you can use to enter to each instance/node via `ssh` if you want.

   ```bash
   aws ec2 create-key-pair --key-name $KEY_PAIR_NAME
   ```

1. Create the EKS cluster on AWS. This step could take several minutes depending of the amount of nodes to be created.

   ```bash
   eksctl create cluster --region $AWS_REGION --version=1.22 --name $CLUSTER_NAME --nodegroup-name standard-workers --node-type $INSTANCE_TYPE --nodes=2 --ssh-access --ssh-public-key $KEY_PAIR_NAME
   ```

   Upon completion you should see a confirmation message that the Cluster was deployed in EKS as below

   ```bash
   2022-08-12 15:45:55 [ℹ]  nodegroup "standard-workers" has 2 node(s)
   2022-08-12 15:45:55 [ℹ]  node "ip-xxx-xxx-xxx-xxx.ec2.internal" is ready
   2022-08-12 15:45:55 [ℹ]  node "ip-xxx-xxx-xx-xx.ec2.internal" is ready
   2022-08-12 15:46:00 [ℹ]  kubectl command should work with "C:\\Users\\xxxxxxx\\.kube\\config", try 'kubectl get nodes'
   2022-08-12 15:46:00 [✔]  EKS cluster "consul-cluster" in "us-east-1" region is ready
   ```

1. Create EKS namespace. This step is intended to wrap all the resources deployed on EKS for this purpose. This also could facilitate the cleaning of resources after

   ```bash
   EKS_NAMESPACE=consul
   kubectl create namespace $EKS_NAMESPACE
   kubectl config set-context --current --namespace=$EKS_NAMESPACE
   ```

1. Add the Hashicorp helm repository to deploy the Consul features through Helm chart:

   ```bash
   helm repo add hashicorp https://helm.releases.hashicorp.com
   ```

   As output you will see the sucess message as below:

   ```bash
   "hashicorp" has been added to your repositories
   ```

1. Deploy Consul features through the Helm chart using the custom deployment file `consul-linux.yaml`. Features enabled: Server, UI and connectInject.

   ```bash
   helm install consul hashicorp/consul --values consul-linux.yaml --version "1.0.0"
   ```

   After finishing you should see a confirmation message that Consul was deployed on EKS cluster as below

   ```bash
   NAME: consul
   LAST DEPLOYED: Fri Aug 5 XX:XX:XX 20XX
   NAMESPACE: consul
   STATUS: deployed
   REVISION: 1
   NOTES:
   Thank you for installing HashiCorp Consul!
   ```

1. You can access Consul's UI and check the server's status. To access the UI you have to forward the port, the example below shows the ports services are running on, with that information you can forward port 80 to localhost:8501 using this command: `kubectl port-forward service/consul-ui --namespace consul 8501:80`.  

   ```bash
   kubectl get svc

   NAME                     TYPE         CLUSTER-IP        EXTERNAL-IP   PORT(S)
   consul-connect-injector  ClusterIP    xx.xx.xx.xx       <none>        443/TCP
   consul-server            ClusterIP    None              <none>        8500/TCP,8502/TCP,8301/TCP,8301/UDP,8302/TCP,8302/UDP,8300/TCP,8600/TCP,8600/UDP
   consul-ui                NodePort     xxx.xxx.xxx.xxx   <none>        80:31951/TCP
   ```

1. Enable support for Windows nodes. Follow the steps described [here](https://docs.aws.amazon.com/eks/latest/userguide/windows-support.html).

1. Once enabled the Windows nodes support, to create the Windows nodes on the EKS cluster enter next command

   ```bash
   eksctl create nodegroup --region $AWS_REGION --cluster=$CLUSTER_NAME --managed=false --name windows-ng --node-ami-family=$WINDOWS_AMI_FAMILY --nodes=2 --node-type=$INSTANCE_TYPE --ssh-access --ssh-public-key $KEY_PAIR_NAME
   ```

   Upon completion you should see a confirmation message that the nodes were deployed to the EKS Cluster as below

   ```bash
   20XX-XX-XX XX:XX:XX [ℹ]  nodegroup "windows-ng" has 2 node(s)
   20XX-XX-XX XX:XX:XX [ℹ]  node "ip-xxx-xxx-xxx-xxx.ec2.internal" is ready
   20XX-XX-XX XX:XX:XX [ℹ]  node "ip-xxx-xxx-xxx-xxx.ec2.internal" is ready
   20XX-XX-XX XX:XX:XX [✔]  created 1 nodegroup(s) in cluster "consul-cluster"
   20XX-XX-XX XX:XX:XX [✔]  created 0 managed nodegroup(s) in cluster "consul-cluster"
   20XX-XX-XX XX:XX:XX [ℹ]  checking security group configuration for all nodegroups
   20XX-XX-XX XX:XX:XX [ℹ]  all nodegroups have up-to-date cloudformation templates
   ```
