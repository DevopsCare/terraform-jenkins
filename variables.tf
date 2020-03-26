/*
 * Copyright (C) 2019 DevOps, SIA. - All Rights Reserved
 * You may use, distribute and modify this code under the
 * terms of the Apache License Version 2.0.
 * http://www.apache.org/licenses
 */

##########
# Naming #
##########
variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = ""
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

#######
# VPC #
#######
variable "vpc_id" {
  description = "ID of an existing VPC where resources will be created"
  type        = string
  default     = ""
}

variable "public_subnet_ids" {
  description = "A list of IDs of existing public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of IDs of existing private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "The CIDR block for the VPC which will be created if `vpc_id` is not specified"
  type        = string
  default     = ""
}

variable "azs" {
  description = "A list of availability zones in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

###########
# Jenkins #
###########
variable "jenkins_instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.medium"
}

variable "jenkins_ami_id" {
  description = "Jenkins AMI id. It's recommended to use https://github.com/DevopsCare/packer-jenkins-ami for AMI building"
  type        = string
  default     = ""
}

variable "jekins_volume_size" {
  description = "EC2 root volume size"
  type        = string
  default     = 20
}

variable "ip_whitelist" {
  description = "IP list will be able to access Jenkins"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "keypair_name" {
  description = "Key pair will be used for EC2 instance"
  type        = string
  default     = ""
}

variable "jenkins_iam_instance_profile" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = ""
}

#######
# ACM #
#######
variable "jenkins_domain_name" {
  description = "Domain will be used for ACM module"
  type        = string
  default     = ""
}

variable "zone_id" {
  description = "The ID of the hosted zone to contain Jenkins domain record"
  type        = string
  default     = ""
}

variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}
