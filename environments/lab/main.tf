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


# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "~> 20.0"

#   cluster_name    = var.cluster_name
#   cluster_version = "1.29"
#   subnet_ids      = module.vpc.public_subnets
#   vpc_id          = module.vpc.vpc_id

#   enable_irsa = true

#   eks_managed_node_groups = {
#     default = {
#       instance_types = ["t3.small"]
#       desired_size   = 1
#       max_size       = 2
#       min_size       = 1
#     }
#   }

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }