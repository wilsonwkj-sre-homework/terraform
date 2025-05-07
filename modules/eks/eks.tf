module "eks" {
  # environment = "lab"
  # eks_cluster_name  = "sre-homework-eks-cluster"
  # vpc_id        = module.vpc.vpc_id
  # subnet_ids    = module.vpc.public_subnet_ids
  # required_tags = {
  #   Project     = "sre-homework"
  #   Environment = "lab"
  # }
  # desired_capacity = 2
  # max_capacity     = 3
  # min_capacity     = 1
  # node_instance_type = "t4g.small"
  source        = "terraform-aws-modules/eks/aws"
  version             = "~> 20.0"
  cluster_name        = "sre-homework-eks-cluster"
  cluster_version     = "1.31"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # vpc_id                   = module.vpc.vpc_id
  # subnet_ids               = module.vpc.public_subnet_ids
  # control_plane_subnet_ids = module.vpc.public_subnet_ids
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    lab = {
      ami_type     = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # iam_role_name = "node-role-lab" # Custom short name
      # iam_role_use_name_prefix = false    # Use fixed name instead of prefix

    }
  }
  tags = {
    Project     = "sre-homework"
    Environment = "${var.environment}"
  }
}