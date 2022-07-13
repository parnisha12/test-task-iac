resource "aws_default_network_acl" "default" {
    default_network_acl_id = aws_vpc.vpc.default_network_acl_id

    egress {
        protocol    = "-1"
        rule_no     = 100
        action      = "allow"
        cidr_block  = "0.0.0.0/0"
        from_port   = "0"
        to_port     = "0"
    }

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    tags = merge(
        {
            Name        = "${var.environment}-nacl"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}