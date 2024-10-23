
# Terraform AWS EKS Module

This repository contains the Terraform configuration for setting up an AWS EKS (Elastic Kubernetes Service) cluster and its associated components like subnets, node groups, IAM roles, and Pod Identity Addon. This module is designed to be reusable and flexible for different environments.



## Overview

This module provisions the following AWS EKS components:
- EKS Cluster with private and public access options.
- IAM roles for the EKS cluster and worker nodes.
- Node groups for deploying EC2 instances as EKS worker nodes.
- AWS EKS Pod Identity Addon for managing service accounts on EKS.

## Requirements

| Name        | Version   |
|-------------|-----------|
| Terraform   | >= 1.0    |
| AWS Provider| ~> 5.49   |

## Providers

| Name | Version |
|------|---------|
| aws  | ~> 5.49 |

## Resources

The following AWS resources are created by this module:

| Resource Type               | Description                            |
|-----------------------------|----------------------------------------|
| `aws_iam_role`               | IAM Role for the EKS Cluster           |
| `aws_eks_cluster`            | EKS Cluster with customizable version  |
| `aws_iam_role_policy_attachment` | Attach policies to IAM roles         |
| `aws_eks_node_group`         | EKS Worker Node Groups                 |
| `aws_eks_addon`              | Pod Identity Addon for EKS             |

## Inputs

| Variable                  | Description                                                                                 | Type       | Default                        |
|---------------------------|---------------------------------------------------------------------------------------------|------------|--------------------------------|
| `env`                      | Environment name (e.g., `dev`, `prod`)                                                      | `string`   | `"dev"`                        |
| `eks_version`              | Desired Kubernetes version for the EKS cluster                                              | `string`   | `"1.21"`                       |
| `eks_name`                 | Name of the EKS cluster                                                                     | `string`   | `"my-cluster"`                 |
| `eks_cluster_permissions`  | Map of permissions for EKS cluster (e.g., endpoint access, authentication mode)             | `map(any)` | See [default values](#default-values) |
| `private_subnet_ids`       | List of private subnet IDs for EKS nodes                                                    | `list(string)` | `[]`                           |
| `node_iam_policies`        | IAM Policies to attach to EKS nodes                                                         | `map(string)` | See [default values](#default-values) |
| `eks_pod_identity_addon`   | Details of the Pod Identity Addon for EKS                                                   | `map(string)` | See [default values](#default-values) |
| `node_groups`              | Configuration for EKS node groups, including instance types and scaling settings            | `map(any)` | See [default values](#default-values) |

### Default Values

Here are the default values for some of the input variables:

```hcl
variable "eks_cluster_permissions" {
  default = {
    endpoint_private_access                     = false
    endpoint_public_access                      = true
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

variable "node_iam_policies" {
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

variable "eks_pod_identity_addon" {
  default = {
    name    = "eks-pod-identity-agent"
    version = "v1.2.0-eksbuild.1"
  }
}

variable "node_groups" {
  default = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.small"]
      scaling_config = {
        desired_size = 1
        max_size     = 10
        min_size     = 0
      }
    }
  }
}
```

## Outputs

| Output Name         | Description                               |
|---------------------|-------------------------------------------|
| `eks_name`          | Name of the created EKS Cluster           |

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "eks_cluster" {
  source              = "./eks"
  env                 = "prod"
  eks_name            = "production-cluster"
  eks_version         = "1.21"
  private_subnet_ids  = ["subnet-12345678", "subnet-87654321"]

  node_groups = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.medium"]
      scaling_config = {
        desired_size = 2
        max_size     = 5
        min_size     = 1
      }
    }
  }
}
```
