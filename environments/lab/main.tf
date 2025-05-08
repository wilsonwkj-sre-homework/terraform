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
  eks_cluster_name    = "sre-homework-eks-cluster"

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
  alb_sg_id = "sg-0d8ceaaef3d874725"
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

module "charts" {
  source = "../../modules/charts"
  environment = "lab"
  region = "ap-southeast-1"
  eks_cluster_name = "sre-homework-eks-cluster"
  cluster_endpoint    = "https://2E2B5476BE923B7FDD9EDF3837600657.gr7.ap-southeast-1.eks.amazonaws.com"
  AWS_ACCOUNT_ID = "797181129561"
  OIDC_ID = "2E2B5476BE923B7FDD9EDF3837600657"
  vpc_id  = module.vpc.vpc_id
}
