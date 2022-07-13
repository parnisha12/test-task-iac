### VPC 
resource "aws_vpc" "vpc" {
    cidr_block                     = var.vpc_cidr
    enable_dns_hostnames           = true
    enable_dns_support             = true

    tags = merge(
        {
            Name        = "${var.environment}-vpc"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

### Gateways
resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = merge(
        {
            Name        = "${var.environment}-igw"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

# resource "aws_nat_gateway" "nat_gateway" {
#     subnet_id     = aws_subnet.private_subnet.id

#     tags = merge(
#         {
#             Name        = "${var.environment}-nat-gw"
#             Environment = "${var.environment}"
#         },
#         var.project_tags
#     )
# }

### Subnets
# Public subnet
resource "aws_subnet" "public_subnet" {
    for_each = var.public_profile

    vpc_id              = aws_vpc.vpc.id
    cidr_block          = each.value["cidr"]   
    availability_zone   = each.value["az"]
    
    tags = merge(
        {
            Name        = "${var.environment}-public-subnet-${each.key}"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
    vpc_id              = aws_vpc.vpc.id
    cidr_block          = "${var.private_subnets_cidr}"
    availability_zone   = data.aws_availability_zones.available.names[0]

    tags = merge(
        {
            Name        = "${var.environment}-private-subnet"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_default_route_table" "public-rt" {
    default_route_table_id = aws_vpc.vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = merge(
        {
            Name        = "${var.environment}-public-route-table"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table_association" "public" {
    for_each = var.public_profile

    subnet_id      = aws_subnet.public_subnet[each.key].id
    route_table_id = aws_default_route_table.public-rt.id
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.vpc.id

    tags = merge(
        {
            Name        = "${var.environment}-private-route-table"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route_table_association" "private" {

    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private-rt.id
}