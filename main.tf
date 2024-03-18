provider "aws" {
  region = "us-east-1"
}

data "aws_ecr_authorization_token" "token" {}

data "aws_ecr_repository" "service" {
  name = "fiap-lanches"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "fiap-lanches-eks"
}

locals {
  cluster_name = "fiap-lanches-eks"
}


resource "aws_kms_key" "fiap-lanches-eks" {}

module "kms" {
  source = "terraform-aws-modules/kms/aws"

  description = "EC2 AutoScaling key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Policy
  # key_administrators                 = ["arn:aws:iam::012345678901:role/admin"]

  # Aliases
  aliases = ["alias/eks/fiap-lanches-eks"]

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

resource "aws_cloudwatch_log_group" "fiap-lanches-eks" {
  name         = "fiap-lanches-eks"
  skip_destroy = false

  tags = {
    Environment = "production"
    Application = "fiap-lanches"
  }
}


module "iam" {
  source  = "terraform-aws-modules/iam/aws"
  version = "5.37.1"
}

module "iam_eks_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-eks-role"

  role_name = "fiap-lanches-role"

  cluster_service_accounts = {
    "fiap-lanches-eks" = ["default:fiap-lanches-eks"]
  }

  depends_on = [module.iam_user]

  tags = {
    Name = "eks-fiap-lanches-role"
  }

  role_policy_arns = {
    AdministratorAccess                    = "arn:aws:iam::aws:policy/AdministratorAccess"
    AmazonEKSClusterPolicy                 = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
    AmazonEKSFargatePodExecutionRolePolicy = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  }
}

module "iam_user" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name                    = "fiap-lanches"
  force_destroy           = true
  password_reset_required = false

  policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ]
}

module "eks" {
  source     = "terraform-aws-modules/eks/aws"
  version    = "20.8.3"
  depends_on = [module.iam_eks_role]

  access_entries = {
    fiap_lanches = {
      principal_arn = "arn:aws:iam::211125342569:user/fiap-lanches"
      policy_associations = {

        view = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }

        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }

        edit = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }

        admin_cluster = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

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
