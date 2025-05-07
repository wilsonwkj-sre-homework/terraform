resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "wilsonwkj-project-srehomework-tfstate-${var.environment}"

    lifecycle {
        prevent_destroy = true
    }

    tags = merge(var.required_tags,{})
}