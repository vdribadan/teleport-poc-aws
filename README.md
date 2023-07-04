# What is Teleport?

Teleport is a powerful tool that allows for the securing of access to servers, Kubernetes clusters, and web applications in any environment. It provides a unified access plane that consolidates access controls and auditing across all environments - infrastructure, applications, and data. Teleport is designed to be compliant with most enterprise security requirements.

This repository provides a simple Terraform example to get you started provisioning an all-in-one Teleport cluster (auth, node, proxy) on a single EC2 instance based on Teleport's pre-built AMI.

Note: This example is not intended for production use! It is designed to provide a demonstration, proof-of-concept, or learning environment.


## What's inside?

This Terraform example will configure the following AWS resources:

- Teleport all-in-one (auth, node, proxy) single cluster ec2 instance
- DynamoDB tables (cluster state, cluster events, ssl lock)
- S3 bucket (session recording storage)
- Route53 `A` record
- Security Groups and IAM roles

## Instructions

### Prerequisites

- terraform v1.0+ [install docs](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- awscli v1.14+ [install docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Teleport CLI (tsh): The tsh command-line tool lets you login to Teleport nodes and Kubernetes clusters, among other things. You can download it from the official Teleport [install docs](https://goteleport.com/download/)downloads page.
- Teleport Control Plane CLI (tctl): The tctl command-line tool allows you to manage your Teleport cluster. It is included with the Teleport package, which you can download from the official Teleport [install docs](https://goteleport.com/download/)downloads page.
- Make sure you have exported AWS credentials
- Check out exampletfvars file for terraform.tfvars posssible values

### Usage
 
- `terraform init` to install aws provider and prepare repo 
- `terraform plan` and verify the plan is building what you expect.
- `terraform apply` to begin provisioning.
- `terraform destroy` to delete the provisioned resources.

### Project layout

File           | Description
-------------- | ---------------------------------------------------------------------------------------------
cluster.tf     | EC2 instance template and provisioning.
cluster_iam.tf | IAM role provisioning. Permits ec2 instance to talk to AWS resources (ssm, s3, dynamodb, etc)
cluster_sg.tf  | Security Group provisioning. Ingress network rules.
data.tf        | Misc variables used for provisioning AWS resources.
data.tpl       | Template for Teleport configuration.
dynamo.tf      | DynamoDB table provisioning. Tables used for Teleport state and events.
route53.tpl    | Route53 zone creation. Requires a hosted zone to configure SSL.
s3.tf          | S3 bucket provisioning. Bucket used for session recording storage.
ssm.tf         | Teleport license distribution (if using Teleport enterprise).
vars.tf        | Inbound variables for Teleport configuration.

### Steps

1. Run `terraform apply`.
2. SSH to your new instance. `ssh ec2-user@<cluster_domain>`.
3. Create a user (this will create a Teleport User and permit login as the local ec2-user).
   - `sudo tctl users add <username> --roles=access,editor --logins=ec2-user`
4. Click the registration link provided by the output. Set a password and configure your 2fa token.
5. Success! You've configured a fully functional Teleport cluster.

