output "eks_name" {
  value = aws_eks_cluster.this.name
}

output "eks_name" {
  value = aws_iam_openid_connect_provider.eks.url
}