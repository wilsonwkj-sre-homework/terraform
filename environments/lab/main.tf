module "state_bucket" {
  source        = "../../modules/state_bucket"
  environment   = "lab"
  required_tags = {
    Project     = "sre-homework"
    Environment = "lab"
  }
}

module "vpc" {
  source              = "../../modules/vpc"
  environment         = "lab"
  project_name        = "sre-homework"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  azs                 = ["ap-southeast-1a", "ap-southeast-1b"]
  eks_cluster_name    = "sre-homework-eks-lab"

  required_tags = {
    Project     = "sre-homework"
    Environment = "lab"
  }
}

module "eks" {
  source          = "../../modules/eks"
  environment   = "lab"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.public_subnet_ids
  control_plane_subnet_ids  = module.vpc.public_subnet_ids
}


module "ecr" {
  source        = "../../modules/ecr"
  project_name        = "sre-homework"
  environment         = "lab"


  required_tags = {
    Project     = "sre-homework"
    Environment = "lab"
  }
}

module "elb" {
  source = "../../modules/elb"
  environment = "lab"
  region = "ap-southeast-1"
  eks_cluster_name = "sre-homework-eks-cluster"
  cluster_endpoint    = "https://2E2B5476BE923B7FDD9EDF3837600657.gr7.ap-southeast-1.eks.amazonaws.com"

  # required_tags = {
  #   Project     = "sre-homework"
  #   Environment = "lab"
  # }
}

# module "lb_role" {
#   source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#   role_name = "sre-homework-eks-lb-lab"
#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     main = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }