# IAM Role for AWS Load Balancer Controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.eks_cluster_name}-aws-lb-controller"

  # Simplified trust policy: Allow the EKS nodes to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Broad permissions for demo
  role       = aws_iam_role.aws_load_balancer_controller.name
  depends_on = [
    aws_iam_role.aws_load_balancer_controller
    ]
}