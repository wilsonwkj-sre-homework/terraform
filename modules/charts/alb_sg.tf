# Security group for the ALB (assuming this exists in your main.tf)
resource "aws_security_group" "alb_sg" {
  name        = "sre-homework-alb-sg"
  description = "Security group for ALB allowing HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sre-homework-alb-sg"
  }
}