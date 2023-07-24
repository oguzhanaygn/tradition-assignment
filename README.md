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
    │   ├── extra-modules/
    │   ├── tasks/
    │       ├── task-one/
    │       ├── task-two/
    │           ├── k8s-deployment-files/
    └── variables.tf

The main purpose of this directory structure is creating shared resources like network infrastructure in root directory and task specific resources in their respective module directories. Also, `data-sources` and `providers` have their specific files to reduce complexity.

Base network infrastructure creation flow ; _**(`network-infra.tf` -> `aws/`  -> `related module`)**_
Task One infrastructures creation flow ; _**(`tasks.tf` -> `tasks` -> `task-one/` -> `aws/` or `extra-modules` -> `related module`)**_
Task Two infrastructures creation flow ; _**(`tasks.tf` -> `tasks` -> `task-two/` -> `aws/` or `extra-modules` -> `related module`)**_

Additionally, there are two directories named `k8s-deployment-files` directory to accomplish nginx deployment after cluster creation and `extra-modules` directory to host extra modules that are not directly associated with aws provider.

## Resources
There are 41 resources in this infrastructure. Distribution of the resources are like below;

#####  Base infrastructure : 
- 9 resources (1 VPC, 3 public subnets, 1 internet gateway, 1 route table, 3 route table associations)
##### Task ne infrastructure : 
- 9 resources (1 Autoscaling Group, 1 Launh Template, 1 tls private key, 1 ssh key pair, 1 security group, 4 security group rules)
##### Task two infrastructure : 
- 23 resources (1 EKS Cluster, 1 EKS Node Group, 1 Launch Template, 1 cloudwatch log group, 2 IAM Role, 1 IAM Policy, 7 role policy attachment, 1 tls private key, 1 ssh key pair, 2 security group, 4 security group rules, 1 local file)

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

#### Task creation steps:
In this setup, both `task_one` and `task_two` variables are predefined as `false`. So, we should overwrite them to create infrastructures. 
If we want to create only the network infrastructure, we should run `terraform plan` and `terraform apply` without any parameters. Since our both infra variables are `false` predefinitively, task specific infrastructures will not be created.

#### Preparation :
aws-cli and terraform should be available,
local versions : 
aws-cli : aws-cli/2.11.2
terraform : Terraform v1.4.6

- `terraform init` should be ran to be able to pull provider dependencies. 

#### Task one :
To be able to create task one components, commands below should be ran;

- `terraform plan -var 'task_one=true'`

- `terraform apply -var 'task_one=true'`

- After the apply is finished, we can go to AWS console and wait for instances to become fully ready.(Status Checks Passed)
When the instances are fully ready, copy the public ip address of the both instances and paste it to browser in order. Both ip addresses are expected to work for both HTTP and HTTPS (https can give certificate warning)

We can even connect the instances with SSH connection with the private key named `test-task-one-key-pair.pem` created during `apply`. 

`ssh -i test-task-one-key-pair.pem ec2-user@instance_public_ip`

#### Task two :

To be able to create task one components, commands below should be ran;

- `terraform plan -var 'task_two=true'`

- `terraform apply -var 'task_two=true'`

These commands above will give the output of task one infra deletion and task two infra creation.

- After the apply step is finished, 

We should pull the cluster context by running `aws eks update-kubeconfig --name test-tradition-cluster --alias test-tradition-cluster` command.

- After pulling the context kubectl automatically switches that context but if want to check it, we can run `kubectl config current-context` command to make sure we are in appropriate context, if we are not, we should run `kubectl config use-context test-tradition-cluster` command.
After this double-check, we can apply the k8s yamls to our infrastructure. 

`kubectl apply -f modules/tasks/task-two/k8s-deployment-files/namespace.yaml` : Creates a namespace for our nginx pods

`kubectl apply -f modules/tasks/task-two/k8s-deployment-files/deployment.yaml` : Deployment file of the nginx pods

`kubectl apply -f modules/tasks/task-two/k8s-deployment-files/service.yaml` : Creates Load Balancer service in AWS, main file is a template but it takes security group variable from terraform infrastructure, render `service.yaml.tpl` and creates service.yaml. 

`kubectl apply -f modules/tasks/task-two/k8s-deployment-files/pdb.yaml` : Creates a Pod Distribution Budget to make sure certain number of pods are always running in any given time.

- To test if task two infrastructure is working or not, we should go to EC2 - Load Balancers page in AWS console or simply run `kubectl get svc nginx-svc -n nginx-test` and copy the FQDN of Load Balancer, paste it to the browser and enter it. 

- Additionally; We can even connect the instances with SSH connection with the private key named `test-task-two-key-pair.pem` created during `apply`. 

`ssh -i test-task-two-key-pair.pem ec2-user@instance_public_ip`

#### Deletion steps :

- `kubectl delete -f modules/tasks/task-two/k8s-deployment-files/` : deletion of the deployment components.

- `terraform destroy` : deletion of the infrastructure components.