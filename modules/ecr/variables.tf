variable "project_name" {
  description = "The name of the project (e.g., sre)"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
}

variable "required_tags" {
    description = "Tags to apply to all resources"
    type          = object({
        Project     = string
        Environment = string
    })
}