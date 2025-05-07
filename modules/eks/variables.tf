variable "environment" {
  type        = string
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
    description = "List of subnet IDs for EKS nodes"
    type        = list(string)
}

variable "required_tags" {
    description = "Tags to apply to all resources"
    type          = object({
        Project     = string
        Environment = string
    })
}

variable "node_instance_type" {
    description = "EC2 instance type for the worker nodes"
    type        = string
}

variable "desired_capacity" {
    description = "Desired number of worker nodes"
    type        = number
}

variable "max_capacity" {
    description = "Maximum number of worker nodes"
    type        = number
}

variable "min_capacity" {
    description = "Minimum number of worker nodes"
    type        = number
}
