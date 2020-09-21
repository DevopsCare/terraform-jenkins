/*
 * Copyright (C) 2019 DevOps, SIA. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

locals {
  vpc_id             = var.vpc_id == "" ? module.vpc.vpc_id : var.vpc_id
  private_subnet_ids = coalescelist(module.vpc.private_subnets, var.private_subnet_ids, [""])
  public_subnet_ids  = coalescelist(module.vpc.public_subnets, var.public_subnet_ids, [""])
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.19.0"
  namespace   = var.namespace
  name        = var.name
  stage       = var.stage
  environment = var.environment
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

data "aws_region" "current" {}

#######
# VPC #
#######
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.0"

  create_vpc = var.vpc_id == ""

  name = module.label.id

  cidr            = var.cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = module.label.tags
}

#######
# ELB #
#######
module "jenkins_elb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = module.label.id
  description = "Security group for Jenkins"
  vpc_id      = local.vpc_id

  ingress_cidr_blocks = var.ip_whitelist

  ingress_rules = [
    "http-80-tcp",
    "https-443-tcp"
  ]

  computed_egress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.jenkins_sg.this_security_group_id
    }
  ]
  number_of_computed_egress_with_source_security_group_id = 1
}

module "jenkins_elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = module.label.id

  subnets         = local.public_subnet_ids
  security_groups = [module.jenkins_elb_sg.this_security_group_id]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port      = "80"
      instance_protocol  = "HTTP"
      lb_port            = "443"
      lb_protocol        = "HTTPS"
      ssl_certificate_id = module.acm.this_acm_certificate_arn
    },
  ]

  health_check = {
    target              = "HTTP:80/login"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances = 1
  instances           = module.jenkins_ec2.id

  tags = module.label.tags
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> v2.0"

  domain_name = var.jenkins_domain_name
  zone_id     = var.zone_id

  subject_alternative_names = var.subject_alternative_names

  tags = module.label.tags
}

resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = var.jenkins_domain_name
  type    = "A"

  alias {
    name                   = module.jenkins_elb.this_elb_dns_name
    zone_id                = module.jenkins_elb.this_elb_zone_id
    evaluate_target_health = true
  }
}

#######
# EC2 #
#######
module "jenkins_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = module.label.id
  description = "Security group for Jenkins"
  vpc_id      = local.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.jenkins_elb_sg.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]
}

module "jenkins_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = module.label.id
  instance_count = 1

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.jekins_volume_size
    },
  ]

  ami                    = var.jenkins_ami_id
  instance_type          = var.jenkins_instance_type
  key_name               = var.keypair_name
  monitoring             = true
  vpc_security_group_ids = [module.jenkins_sg.this_security_group_id]
  subnet_ids             = local.private_subnet_ids

  iam_instance_profile = var.jenkins_iam_instance_profile

  tags = module.label.tags
}
