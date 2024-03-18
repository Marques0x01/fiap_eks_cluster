provider "aws" {
  region = "us-east-1"
}

data "aws_ecr_authorization_token" "token" {}

data "aws_ecr_repository" "service" {
  name = "fiap-lanches"
}

# data "aws_availability_zones" "available" {
#   filter {
#     name   = "opt-in-status"
#     values = ["opt-in-not-required"]
#   }
# }

# module "vpc" {
#   # depends_on = [ data.aws_vpcs.selected ]
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.6.0"
#   create_vpc = false
#   name = "fiap-lanches-vpc"
#   cidr = "172.31.0.0/16"
#   azs  = slice(data.aws_availability_zones.available.names, 0, 3)

#   public_subnets  = ["172.31.0.0/20	", "172.31.80.0/20", "172.31.16.0/20"]

#   enable_nat_gateway   = true
#   single_nat_gateway   = true
#   enable_dns_hostnames = true

#   public_subnet_tags = {
#     "kubernetes.io/cluster/${local.cluster_name}" = "shared"
#     "kubernetes.io/role/elb"                      = 1
#   }

#   tags = {
#     Terraform = "true"
#     Environment = "fiap-lanches-prod-vpc"
#   }
# }

data "aws_eks_cluster_auth" "cluster" {
  name = "fiap-lanches-eks"
}

locals {
  cluster_name = "fiap-lanches-eks"
}


resource "aws_kms_key" "fiap-lanches-eks" {}

resource "aws_kms_alias" "fiap-lanches-eks" {
  name          = "alias/eks/fiap-lanches-eks"
  target_key_id = aws_kms_key.fiap-lanches-eks.key_id
}

resource "aws_cloudwatch_log_group" "fiap-lanches-eks" {
  name         = "fiap-lanches-eks"
  skip_destroy = false

  tags = {
    Environment = "production"
    Application = "fiap-lanches"
  }
}

resource "aws_kms_key" "fiap-lanches-eks" {}

resource "aws_kms_alias" "fiap-lanches-eks" {
  name          = "alias/eks/fiap-lanches-eks"
  target_key_id = aws_kms_key.fiap-lanches-eks.key_id
}

resource "aws_cloudwatch_log_group" "fiap-lanches-eks" {
  name = "fiap-lanches-eks"
  skip_destroy = false

  tags = {
    Environment = "production"
    Application = "fiap-lanches"
  }
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id = "vpc-068207d590edc3748"
  subnet_ids = ["subnet-0cff870d98841b1f7",
    "subnet-03a3d01b444be36f9",
  "subnet-09668b48379dbd6c5"]
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
