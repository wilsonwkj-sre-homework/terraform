module "state_bucket" {
  source      = "../../modules/state_bucket"
  environment = "lab"
  required_tags = {
    Project     = "sre-homework"
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}