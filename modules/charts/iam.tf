# IAM Role for AWS Load Balancer Controller
resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.eks_cluster_name}-lb-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${var.AWS_ACCOUNT_ID}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.OIDC_ID}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "oidc.eks.${var.region}.amazonaws.com/id/${var.OIDC_ID}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" # Broad permissions for demo
  role       = aws_iam_role.aws_load_balancer_controller.name
  depends_on = [
    aws_iam_role.aws_load_balancer_controller
    ]
}

# Attach the pre-made AWS policy for ALB Controller
resource "aws_iam_role_policy_attachment" "lb_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.aws_load_balancer_controller.name
  depends_on = [
      aws_iam_role_policy_attachment.aws_load_balancer_controller_policy
    ]
}