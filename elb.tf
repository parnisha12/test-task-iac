resource "aws_lb" "elb" {
    name                = "${var.environment}-elb"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [aws_security_group.security_group.id]
    subnets             = [aws_subnet.public_subnet["subnet_1"].id, aws_subnet.public_subnet["subnet_2"].id]

    tags = merge(
        {
            Name        = "${var.environment}-elb"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}

resource "aws_lb_target_group" "http" {
    name     = "${var.environment}-lb-http-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_target_group" "https" {
    name     = "${var.environment}-lb-https-tg"
    port     = 443
    protocol = "HTTPS"
    vpc_id   = aws_vpc.vpc.id
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.elb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.http.arn
    }
}

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.elb.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08"
    certificate_arn   = aws_iam_server_certificate.test_cert.arn

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.https.arn
    }
}
