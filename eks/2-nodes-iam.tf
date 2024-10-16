resource "aws_iam_role" "nodes" {
  name = "${var.env}-${var.eks_name}-eks-nodes"

  assume_role_policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Action = "sts:AssumeRole"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }
  ]
})
}


# This policy now includes AssumeRoleForPodIdentity for the Pod Identity Agent
resource "aws_iam_role_policy_attachment" "nodes" {
  for_each = var.node_iam_policies

  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}