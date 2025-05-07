# Helm provider to install AWS Load Balancer Controller
provider "helm" {
  kubernetes {
    host = var.cluster_endpoint
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name, "--region", var.region, "--profile", "wilsonwkj-aws-${var.environment}"]
    }
    insecure = true
  }
}