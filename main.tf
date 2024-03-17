provider "aws" {
  region = "sa-east-1"
}

data "aws_ecr_authorization_token" "token" {}

data "aws_ecr_repository" "service" {
  name = "fiap-lanches"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "fiap-lanches-eks-cWTzWOQb"
}

locals {
  cluster_name = "fiap-lanches-eks-cWTzWOQb"
}

resource "aws_kms_key" "fiap-lanches-eks-cWTzWOQb" {}

resource "aws_kms_alias" "fiap-lanches-eks-cWTzWOQb" {
  name          = "alias/eks/fiap-lanches-eks-cWTzWOQb"
  target_key_id = aws_kms_key.fiap-lanches-eks-cWTzWOQbs.key_id
}

resource "aws_cloudwatch_log_group" "fiap-lanches-eks-cWTzWOQb" {
  name = "fiap-lanches-eks-cWTzWOQb"
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

  vpc_id                         = "vpc-0752727b0f51764fc"
  subnet_ids                     = ["subnet-00ce4adb6c30c8ae1", "subnet-00112381be80c7d94", "subnet-053702fcb1e019f87"]
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

    two = {
      name = "node-group-2"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}
