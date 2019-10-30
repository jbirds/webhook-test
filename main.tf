# Connect to the core-logging account to get VPC FlowLog destinations
data "terraform_remote_state" "logging" {
  backend = "atlas"

  config {
    name    = "CloudOps/core-logging-vpc-flowlogs"
    address = "https://tfe.spehosting.com"
  }
}

# VPCs
module "vpc_primary" {
  source  = "tfe.spehosting.com/CloudOps/vpc/aws"
  version = "1.1.3"

  name            = "${var.name}"
  cidr            = "${var.cidr_primary}"
  azs             = "${var.azs_primary}"
  private_subnets = "${var.private_subnets_primary}"
  tags            = "${var.tags}"

  assign_generated_ipv6_cidr_block        = "${var.assign_generated_ipv6_cidr_block}"
  vpc_flowlogs_cloudwatch_destination_arn = "${data.terraform_remote_state.logging.vpc_flowlogs_us_west_2_destination_arn}"
}

module "vpc_secondary" {
  source  = "tfe.spehosting.com/CloudOps/vpc/aws"
  version = "1.1.3"

  name            = "${var.name}"
  cidr            = "${var.cidr_secondary}"
  azs             = "${var.azs_secondary}"
  private_subnets = "${var.private_subnets_secondary}"
  tags            = "${var.tags}"

  assign_generated_ipv6_cidr_block        = "${var.assign_generated_ipv6_cidr_block}"
  vpc_flowlogs_cloudwatch_destination_arn = "${data.terraform_remote_state.logging.vpc_flowlogs_us_east_1_destination_arn}"

  providers {
    aws = "aws.us-east-1"
  }
}

module "coreaccount-baseline" {
  source  = "tfe.spehosting.com/CloudOps/coreaccount-baseline/aws"
  version = "0.0.8"
  account_name = "${var.name}"

  providers = {
    "aws"                = "aws"
    "aws.ap-northeast-1" = "aws.ap-northeast-1"
    "aws.ap-northeast-2" = "aws.ap-northeast-2"
    "aws.ap-south-1"     = "aws.ap-south-1"
    "aws.ap-southeast-1" = "aws.ap-southeast-1"
    "aws.ap-southeast-2" = "aws.ap-southeast-2"
    "aws.ca-central-1"   = "aws.ca-central-1"
    "aws.eu-central-1"   = "aws.eu-central-1"
    "aws.eu-west-1"      = "aws.eu-west-1"
    "aws.eu-west-2"      = "aws.eu-west-2"
    "aws.eu-west-3"      = "aws.eu-west-3"
    "aws.sa-east-1"      = "aws.sa-east-1"
    "aws.us-east-1"      = "aws.us-east-1"
    "aws.us-east-2"      = "aws.us-east-2"
    "aws.us-west-1"      = "aws.us-west-1"
    "aws.us-west-2"      = "aws.us-west-2"
  }
}


module "core-logging-baseline" {
  source  = "tfe.spehosting.com/CloudOps/coreaccount-baseline/aws//modules/Corelogging-iam-policy"
  version = "0.0.9"
}

# Account baseline
// module "account-baseline" {
//   source  = "tfe.spehosting.com/CloudOps/account-baseline/aws"
//   version = "1.2.0"

//   account_name = "${var.name}"

//   providers = {
//     "aws"                = "aws"
//     "aws.ap-northeast-1" = "aws.ap-northeast-1"
//     "aws.ap-northeast-2" = "aws.ap-northeast-2"
//     "aws.ap-south-1"     = "aws.ap-south-1"
//     "aws.ap-southeast-1" = "aws.ap-southeast-1"
//     "aws.ap-southeast-2" = "aws.ap-southeast-2"
//     "aws.ca-central-1"   = "aws.ca-central-1"
//     "aws.eu-central-1"   = "aws.eu-central-1"
//     "aws.eu-west-1"      = "aws.eu-west-1"
//     "aws.eu-west-2"      = "aws.eu-west-2"
//     "aws.eu-west-3"      = "aws.eu-west-3"
//     "aws.sa-east-1"      = "aws.sa-east-1"
//     "aws.us-east-1"      = "aws.us-east-1"
//     "aws.us-east-2"      = "aws.us-east-2"
//     "aws.us-west-1"      = "aws.us-west-1"
//     "aws.us-west-2"      = "aws.us-west-2"
//   }
// }
