resource "aws_route53_zone" "test" {
    name            = "${var.domain_name}"
    comment         = "Test DNS Record"
    force_destroy   = true
    
    tags = merge(
        {
            Name        = "${var.environment}-route53"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_route53_record" "cname_elb" {
    zone_id = aws_route53_zone.test.zone_id
    name    = "www.${var.domain_name}"
    type    = "CNAME"
    ttl     = 60
    records = [aws_lb.elb.dns_name]
}