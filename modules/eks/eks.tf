# EKS Cluster
resource "aws_eks_cluster" "this" {
    name     = "${var.eks_cluster_name}-${var.environment}"
    role_arn = aws_iam_role.eks_cluster.arn

    vpc_config {
        subnet_ids = var.subnet_ids
        security_group_ids = [aws_security_group.eks_cluster.id]
        endpoint_public_access  = true
        endpoint_private_access = false
    }

    tags = merge(var.required_tags, {
        Name = "${var.eks_cluster_name}-${var.environment}"
    })

    # Ensure IAM role exists first
    depends_on = [
        aws_iam_role.eks_cluster,
        aws_iam_role.eks_node,
        aws_iam_role_policy_attachment.eks_cluster_policy,
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_instance_profile.eks_node,
        aws_security_group.eks_cluster
    ]
}

# Launch Template for EKS Node Group
resource "aws_launch_template" "eks_nodes_launch_template" {
    name = "${var.eks_cluster_name}-launch-template-${var.environment}"
    description = "Launch template for EKS node group"

    vpc_security_group_ids = [aws_security_group.eks_nodes.id]

    tags = merge(var.required_tags, {
        Name = "${var.eks_cluster_name}-launch-template-${var.environment}"
    })

    depends_on = [
        aws_security_group.eks_cluster
    ]
}

# EKS Node Group
resource "aws_eks_node_group" "this" {
    cluster_name    = aws_eks_cluster.this.name
    node_role_arn   = aws_iam_role.eks_node.arn
    subnet_ids      = var.subnet_ids
    instance_types  = [var.node_instance_type]
    ami_type        = "AL2_ARM_64"
    capacity_type   = "ON_DEMAND"

    launch_template {
        id      = aws_launch_template.eks_nodes_launch_template.id
        version = "$Latest"
    }

    scaling_config {
        desired_size = var.desired_capacity
        max_size     = var.max_capacity
        min_size     = var.min_capacity
    }

    tags = merge(var.required_tags, {
        Name = "${var.eks_cluster_name}-node-group-${var.environment}"
    })

    # Must wait for:
    # 1. eks cluster
    # 2. Node IAM role
    # 3. Instance profile 
    # 4. Security group
    # 5. lauch template for worker nodes
    depends_on = [
        aws_iam_role.eks_cluster,
        aws_iam_role.eks_node,
        aws_iam_role_policy_attachment.eks_cluster_policy,
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_instance_profile.eks_node,
        aws_eks_cluster.this,
        aws_security_group.eks_nodes,
        aws_launch_template.eks_nodes_launch_template
    ]
}