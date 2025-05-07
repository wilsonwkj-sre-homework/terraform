resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.8.2"

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    aws_iam_role_policy_attachment.aws_load_balancer_controller_policy
  ]
}

resource "helm_release" "nginx_app" {
    name       = "nginx-app"
    chart      = "./nginx-app"
    namespace  = "default"

    set {
      name  = "image.repository"
      value = "797181129561.dkr.ecr.ap-southeast-1.amazonaws.com/custom-nginx"
    }
    set {
      name  = "image.tag"
      value = "latest"
    }
    set {
      name  = "ingress.hosts[0].host"
      value = "nginx.example.com"
    }

    depends_on = [helm_release.aws_load_balancer_controller]
  }