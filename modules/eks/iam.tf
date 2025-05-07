# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
    name = "${var.eks_cluster_name}-cluster-role-${var.environment}"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action    = "sts:AssumeRole"
        Principal = {
            Service = "eks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
    }]
    })
    tags = merge(var.required_tags, {
        Name = "${var.eks_cluster_name}-cluster-role-${var.environment}"
    })
}

# Cluster policies
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    role       = aws_iam_role.eks_cluster.name
    depends_on = [
        aws_iam_role.eks_cluster
    ]   
}

# Node policies (REQUIRED for node registration)
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    role       = aws_iam_role.eks_node.name
    depends_on = [
            aws_iam_role.eks_cluster
    ]  
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    role       = aws_iam_role.eks_node.name
    depends_on = [
        aws_iam_role.eks_cluster
    ]  
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node" {
    name = "${var.eks_cluster_name}-node-role-${var.environment}"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action    = "sts:AssumeRole"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
            Effect    = "Allow"
            Sid       = ""
        }
    ]
    })
    tags = merge(var.required_tags, {
        Name = "${var.eks_cluster_name}-node-role-${var.environment}"
    })
}

# Instance profile (critical for nodes)
resource "aws_iam_instance_profile" "eks_node" {
    name = "${var.eks_cluster_name}-node-profile-${var.environment}"
    role = aws_iam_role.eks_node.name
    depends_on = [
        aws_iam_role.eks_node
    ]
}