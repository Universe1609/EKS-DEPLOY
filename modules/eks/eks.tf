resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = var.policy
  role       = aws_iam_role.rol.name
}

resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.iam_role

  vpc_config {
    subnet_ids = [
      var.private_a,
      var.private_b,
      var.public_a,
      var.public_b
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.eks_cluster]
}
