terraform {
  backend "s3" {
    bucket         = "wilsonwkj-project-srehomework-tfstate-lab"
    key            = "lab/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    # dynamodb_table = "terraform-locks-lab"
    profile = "wilsonwkj-aws-lab"
  }
}