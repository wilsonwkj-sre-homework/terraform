resource "aws_vpc" "this" {
    cidr_block           = var.vpc_cidr
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = merge(var.required_tags,{
    Name = "${var.project_name}-vpc-${var.environment}"
    })
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = merge(var.required_tags,{
    Name = "${var.project_name}-igw-${var.environment}"
    })
    depends_on = [aws_vpc.this]
}

resource "aws_subnet" "public" {
    count             = length(var.public_subnet_cidrs)
    vpc_id            = aws_vpc.this.id
    cidr_block        = var.public_subnet_cidrs[count.index]
    availability_zone = element(var.azs, count.index)
    map_public_ip_on_launch = true

    tags = merge(var.required_tags,{
    Name                                        = "${var.project_name}-public-${var.environment}-${count.index}"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
    })
    depends_on = [aws_vpc.this]
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    tags = merge(var.required_tags,{
    Name = "${var.project_name}-public-rt-${var.environment}"
    })
    depends_on = [aws_vpc.this]
}

resource "aws_route" "internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.this.id
    depends_on = [aws_internet_gateway.this, aws_route_table.public]
}

resource "aws_route_table_association" "public" {
    count          = length(aws_subnet.public)
    subnet_id      = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
    depends_on = [aws_subnet.public, aws_route_table.public]

}
