# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = module.eks.eks_managed_node_groups["lab"].iam_role_arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups   = ["system:bootstrappers", "system:nodes"]
#       }
#     ])
#     mapUsers = yamlencode([
#       {
#         userarn  = "arn:aws:iam::797181129561:user/WilsonWKJ" 
#         username = "WilsonWKJ"
#         groups   = ["system:masters"]
#       }
#     ])
#   }

#   depends_on = [module.eks]
# }