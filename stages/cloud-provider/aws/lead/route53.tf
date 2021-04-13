data "aws_route53_zone" "root_zone" {
  name = var.root_zone_name
}

resource "aws_route53_zone" "cluster_zone" {
  name = "${var.cluster_name}.${data.aws_route53_zone.root_zone.name}"
  tags = local.tags
}

resource "aws_route53_record" "cluster_zone" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "${var.cluster_name}.${data.aws_route53_zone.root_zone.name}"
  type    = "NS"
  ttl     = "30"

  records = [
    aws_route53_zone.cluster_zone.name_servers[0],
    aws_route53_zone.cluster_zone.name_servers[1],
    aws_route53_zone.cluster_zone.name_servers[2],
    aws_route53_zone.cluster_zone.name_servers[3],
  ]
}

data "aws_vpc" "shared_service_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_vpc" "internal_vpn_vpc" {
  tags = {
    Name = var.vpc_name
  }
}

// adding a private and public zone for split DNS

resource "aws_route53_zone" "private_internal_services_liatr_io" {
  name = "int.rode.${var.cluster_name}.${var.root_zone_name}"

  vpc {
    vpc_id = data.aws_vpc.shared_service_vpc.id
  }

  tags = {
    Environment = "sharedsvc"
    Client      = "liatrio"
    Project     = "Network Infrastructure"
    Owner       = "Liatrio"
    Provisioner = "terraform:liatrio/lead-terraform"
    Private     = "true"
  }
}

resource "aws_route53_zone" "public_internal_services_liatr_io" {
  name = "int.rode.${var.cluster_name}.${var.root_zone_name}"

  tags = {
    Environment = "sharedsvc"
    Client      = "liatrio"
    Project     = "Network Infrastructure"
    Owner       = "Liatrio"
    Provisioner = "terraform:liatrio/lead-terraform"
    Public      = "true"
  }
}

resource "aws_route53_record" "services_liatr_io_ns" {
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = "int.rode.${var.cluster_name}.${var.root_zone_name}"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.public_internal_services_liatr_io.name_servers
}

resource "aws_route53_zone_association" "internal_vpn" {
  zone_id = aws_route53_zone.private_internal_services_liatr_io.zone_id
  vpc_id  = data.aws_vpc.internal_vpn_vpc.id
}
