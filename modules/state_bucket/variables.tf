variable "environment" {
  type        = string
}

variable "required_tags" {
  type    = object({
    Project     = string
    Environment = string
  })
}

