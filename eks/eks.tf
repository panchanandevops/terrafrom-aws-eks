resource "aws_iam_role" "this" {
  name = "${var.env}-${var.eks_name}-eks-cluster"

 assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.this.name
}

resource "aws_eks_cluster" "this" {
  name     = "${var.env}-${var.eks_name}"
  version  = var.eks_version
  role_arn = aws_iam_role.this.arn

  vpc_config {
    endpoint_private_access = var.eks_cluster_permissions.endpoint_private_access
    endpoint_public_access  = var.eks_cluster_permissions.endpoint_public_access

    subnet_ids = var.private_subnet_ids
  }

  access_config {
    authentication_mode                         = var.eks_cluster_permissions.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.eks_cluster_permissions.bootstrap_cluster_creator_admin_permissions
  }

  depends_on = [aws_iam_role_policy_attachment.this]
}