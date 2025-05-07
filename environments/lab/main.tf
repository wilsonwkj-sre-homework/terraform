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
  # eks_cluster_name  = "sre-homework-eks-cluster"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.public_subnet_ids
  control_plane_subnet_ids  = module.vpc.public_subnet_ids
  # subnet_ids    = module.vpc.public_subnet_ids
  # required_tags = {
  #   Project     = "sre-homework"
  #   Environment = "lab"
  # }
  # desired_capacity = 2
  # max_capacity     = 3
  # min_capacity     = 1
  # node_instance_type = "t4g.small"
  
  # source        = "terraform-aws-modules/eks/aws"
  # version             = "~> 20.0"
  # cluster_name        = "sre-homework-eks-cluster"
  # cluster_version     = "1.31"

  # cluster_endpoint_public_access = true

  # cluster_addons = {
  #   coredns = {
  #     most_recent = true
  #   }
  #   kube-proxy = {
  #     most_recent = true
  #   }
  #   vpc-cni = {
  #     most_recent = true
  #   }
  # }

  # vpc_id                   = module.vpc.vpc_id
  # subnet_ids               = module.vpc.public_subnet_ids
  # control_plane_subnet_ids = module.vpc.public_subnet_ids

  # eks_managed_node_groups = {
  #   lab = {
  #     ami_type     = "AL2023_x86_64_STANDARD"
  #     instance_types = ["t3.small"]
  #     capacity_type  = "ON_DEMAND"

  #     min_size     = 1
  #     max_size     = 3
  #     desired_size = 2

  #     # iam_role_name = "node-role-lab" # Custom short name
  #     # iam_role_use_name_prefix = false    # Use fixed name instead of prefix

  #   }
  # }
  # tags = {
  #   Project     = "sre-homework"
  #   Environment = "lab"
  # }
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

# module "elb" {
#   source = "../../modules/elb"
#   environment = "lab"
#   region = "ap-southeast-1"
#   eks_cluster_name = "sre-homework-eks-cluster"
#   oidc_provider_arn = module.eks.oidc_provider_arn
#   oidc_provider = module.eks.oidc_provider

#   # required_tags = {
#   #   Project     = "sre-homework"
#   #   Environment = "lab"
#   # }
# }