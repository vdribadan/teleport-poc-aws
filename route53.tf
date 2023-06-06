resource "aws_route53_record" "cluster" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = var.route53_domain
  type    = "A"
  ttl     = 300
  records = [aws_instance.cluster.public_ip]
}

resource "aws_route53_record" "wildcard-cluster" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "*.${var.route53_domain}"
  type    = "A"
  ttl     = 300
  records = [aws_instance.cluster.public_ip]
  count   = var.add_wildcard_route53_record ? 1 : 0
}
