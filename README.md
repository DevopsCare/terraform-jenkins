# Jenkins (EC2) Terraform module

## Usage

```hcl
module "jenkins" {
  source = "git::https://github.com/DevopsCare/terraform-jenkins.git?ref=master"

  source      = "../"
  name        = "jenkins"
  environment = "dev"
  azs         = ["us-east-1a"]
  cidr        = "10.0.0.0/16"

  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24"]

  jenkins_ami_id = "ami-0bffbab661e4887b1"
  keypair_name   = "dev"

  zone_id                   = "Z12345643J95JTCWLP2AS"
  jenkins_domain_name       = "jenkins.dev.example.com"
  subject_alternative_names = ["jenkins-test.dev.example.com"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| attributes | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| azs | A list of availability zones in the region | `list(string)` | `[]` | no |
| cidr | The CIDR block for the VPC which will be created if `vpc_id` is not specified | `string` | `""` | no |
| delimiter | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes` | `string` | `"-"` | no |
| environment | Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT' | `string` | `""` | no |
| ip\_whitelist | IP list will be able to access Jenkins | `list` | <code>["0.0.0.0/0"]</code> | no |
| jekins\_volume\_size | EC2 root volume size | `string` | `20` | no |
| jenkins\_ami\_id | Jenkins AMI id. It's recommended to use https://github.com/DevopsCare/packer-jenkins-ami for AMI building | `string` | `""` | no |
| jenkins\_domain\_name | Domain will be used for ACM module | `string` | `""` | no |
| jenkins\_iam\_instance\_profile | The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile | `string` | `""` | no |
| jenkins\_instance\_type | The type of instance to start | `string` | `"t3.medium"` | no |
| keypair\_name | Key pair will be used for EC2 instance | `string` | `""` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | `string` | `""` | no |
| namespace | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `""` | no |
| private\_subnet\_ids | A list of IDs of existing private subnets inside the VPC | `list(string)` | `[]` | no |
| private\_subnets | A list of private subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnet\_ids | A list of IDs of existing public subnets inside the VPC | `list(string)` | `[]` | no |
| public\_subnets | A list of public subnets inside the VPC | `list(string)` | `[]` | no |
| stage | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `""` | no |
| subject\_alternative\_names | A list of domains that should be SANs in the issued certificate | `list(string)` | `[]` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |
| vpc\_id | ID of an existing VPC where resources will be created | `string` | `""` | no |
| zone\_id | The ID of the hosted zone to contain Jenkins domain record | `string` | `""` | no |

## Outputs

No output.

