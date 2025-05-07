output "eks_node_role_arn" {
  value = aws_iam_role.eks_node.arn
  description = "The ARN of the IAM role for the EKS worker node"
}