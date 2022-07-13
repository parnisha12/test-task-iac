resource "aws_iam_server_certificate" "test_cert" {
    name             = "${var.environment}-crt"
    certificate_body = file("./certs/server.crt")
    private_key      = file("./certs/server.key")

    tags = merge(
        {
            Name        = "${var.environment}-crt"
            Environment = "${var.environment}"
        },
        var.project_tags
    )
}