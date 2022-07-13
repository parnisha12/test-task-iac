resource "aws_security_group" "security_group" {
    name        = "${var.environment}-sg"
    description = "Allow http and https inbound traffic"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        description      = "http from internet"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr]
    }

    ingress {
        description      = "https from internet"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = [var.vpc_cidr]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = merge(
        {
            Name        = "${var.environment}-sg"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}