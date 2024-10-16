resource "aws_eks_addon" "pod_identity" {
  cluster_name  = aws_eks_cluster.this.name
  addon_name    = var.eks_pod_identity_addon.name
  addon_version = var.eks_pod_identity_addon.version
}