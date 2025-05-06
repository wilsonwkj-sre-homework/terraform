variable "environment" {
  type        = string
}

variable "required_tags" {
  type          = object({
    Project     = string
    Environment = string
  })
}

variable "project_name" {
  type        = string
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "eks_cluster_name" {
  description = "EKS cluster name for subnet tagging"
  type        = string
}