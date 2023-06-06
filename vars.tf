variable "region" {
  description = "AWS region"
  type = string
}

variable "cluster_name" {
  description = "Name of the cluster"
  type = string
}

variable "ami_name" {
  description = "Name for AMI"
  type = string
}

variable "route53_zone" {
  description = "DNS zone name"
  type = string
}

variable "route53_domain" {
  description = "Your domain name"
  type = string
}

variable "add_wildcard_route53_record" {
  description = "Wildcard entris for app access"
  type = bool
}

variable "enable_mongodb_listener" {
  description = "Adding listeners"
  type    = bool
  default = false
}

variable "enable_mysql_listener" {
  description = "Adding listeners"
  type    = bool
  default = false
}

variable "enable_postgres_listener" {
  description = "Adding listeners"
  type    = bool
  default = false
}

variable "s3_bucket_name" {
  description = "Bucket name for storing certs"
  type = string
}

variable "email" {
  description = "E-mail for letsencrypt"
  type = string
}

variable "key_name" {
  description = "SSH key for provisioning instances"
  type = string
}

variable "use_letsencrypt" {
  description = "Consent on using letsencrypt certs"
  type = bool
}

variable "use_acm" {
  description = "Whether to use Amazon issued certs"
  type = bool
}

variable "allowed_ssh_ingress_cidr_blocks" {
  description = "SSH CIDR blocks"
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "allowed_ingress_cidr_blocks" {
  description = "Teleport allowed ports"
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "allowed_egress_cidr_blocks" {
  description = "Egress allowed"
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "cluster_instance_type" {
  description = "Instance type"
  type    = string
  default = "t3.nano"
}
