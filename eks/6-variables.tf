variable "env" {
  description = "Environment name."
  type        = string
}

variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
}

variable "eks_name" {
  description = "Name of the cluster."
  type        = string
}

variable "eks_cluster_permissions" {
  description = "EKS endpoint private access"
  type        = map(any)
  default = {
    endpoint_private_access                     = false
    endpoint_public_access                      = true
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = true
  }
}

variable "private_subnet_ids" {
  description = "List of subnet IDs. Must be in at least two different availability zones."
  type        = list(string)
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(string)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }
}

variable "eks_pod_identity_addon" {
  description = "EKS Pod Identity Addon details"
  type        = map(string)

  default = {
    name    = "eks-pod-identity-agent"
    version = "v1.2.0-eksbuild.1"
  }
}
variable "node_groups" {
  description = "EKS node groups"
  type        = map(any)
  default = {
    general = {
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.small"]
      scaling_config = {
        desired_size = 1
        max_size     = 10
        min_size     = 0
      }
      update_config = {
        max_unavailable = 1
      }
    }
  }
}

