## Introduction
This assignment consists of two parts. One is creating an Autoscaling Group with Apache deployed to it, second is creating an EKS Cluster and its components and nginx deployment components. To be able to create/destroy them seperately, `task_one` and `task_two` variables are used.

Apart from the task components, there is VPC components that defines the base infrastructure for the tasks.

## Structure
Repo structure is like below.

    ├── network-infra.tf
    ├── data-sources.tf
    ├── providers.tf
    ├── tasks.tf
    ├── modules/
    │   ├── aws/
    │   ├── tasks/
    │       ├── task-one/
    │       ├── task-two/
    │           ├── k8s-deployment-files/
    └── variables.tf

The main purpose of this directory structure is creating shared resources like network infrastructure in root directory and task specific resources in their respective module directories. Also, `data-sources` and `providers` have their specific files to reduce complexity.

Base network infrastructure creation flow ; _**(`network-infra.tf` -> `aws/`  -> `related module`)**_
Task One infrastructures creation flow ; _**(`tasks.tf` -> `tasks` -> `task-one/` -> `aws/`  -> `related module`)**_
Task Two infrastructures creation flow ; _**(`tasks.tf` -> `tasks` -> `task-two/` -> `aws/`  -> `related module`)**_

Additionally, there is k8s-deployment-files directory to accomplish nginx deployment after cluster creation.

## Resources
There are 40 resources in this infrastructure. Distribution of the resources are like below;

#####  Base infrastructure : 
- 9 resources (1 VPC, 3 public subnets, 1 internet gateway, 1 route table, 3 route table associations)
##### Task ne infrastructure : 
- 9 resources (1 Autoscaling Group, 1 Launh Template, 1 tls private key, 1 ssh key pair, 1 security group, 4 security group rules)
##### Task two infrastructure : 
- 22 resources (1 EKS Cluster, 1 EKS Node Group, 1 Launch Template, 1 cloudwatch log group, 2 IAM Role, 1 IAM Policy, 7 role policy attachment, 1 tls private key, 1 ssh key pair, 2 security group, 4 security group rules)

## How it works 

#### Plan

`terraform plan` : Plan output of base network infrastructure

`terraform plan -var 'task_one=true'` : Plan output of base network and task one infrastructures

`terraform plan -var 'task_two=true'` : Plan output of base network and task two infrastructures

`terraform plan -var 'task_one=true' -var 'task_two=true'` : Plan output of whole infrastructure

#### Apply

`terraform apply` : Application output of base network infrastructure

`terraform apply -var 'task_one=true'` : Application output of base network and task one infrastructures

`terraform apply -var 'task_two=true'` : Application output of base network and task two infrastructures

`terraform apply -var 'task_one=true' -var 'task_two=true'` : Application output of whole infrastructure