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
  source        = "../../modules/eks"
  environment = "lab"
  eks_cluster_name  = "sre-homework-eks-cluster"
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.public_subnet_ids
  required_tags = {
    Project     = "sre-homework"
    Environment = "lab"
  }
  desired_capacity = 2
  max_capacity     = 3
  min_capacity     = 1
  node_instance_type = "t4g.nano"
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