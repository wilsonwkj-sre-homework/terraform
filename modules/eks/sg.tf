# Security Group for EKS Control Plane
resource "aws_security_group" "eks_cluster" {
  name        = "${var.eks_cluster_name}-sg-${var.environment}"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.required_tags, {
    Name = "${var.eks_cluster_name}-sg-${var.environment}"
  })
}

# Security Group for EKS Worker Nodes
resource "aws_security_group" "eks_nodes" {
  name        = "${var.eks_cluster_name}-nodes-sg-${var.environment}"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow control plane to communicate with nodes"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    description     = "Allow control plane to communicate with kubelet"
    from_port       = 10250
    to_port         = 10250
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    description = "Allow node-to-node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.required_tags, {
    Name = "${var.eks_cluster_name}-nodes-sg-${var.environment}"
  })
}