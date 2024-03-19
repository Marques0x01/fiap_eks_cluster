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



module "kms" {
  source = "terraform-aws-modules/kms/aws"


  description = "EC2 AutoScaling key usage"
  key_usage   = "ENCRYPT_DECRYPT"

  # Aliases
  aliases = ["alias/eks/fiap-eks-kms"]

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

# resource "aws_eks_access_entry" "fiap_lanches-eks" {
#   depends_on    = [module.eks]
#   cluster_name  = module.eks.cluster_name
#   principal_arn = "arn:aws:iam::211125342569:user/jamal"
#   type          = "STANDARD"
#   user_name     = "arn:aws:iam::211125342569:user/jamal"
# }

resource "aws_kms_key" "fiap_lanches_eks" {
  description             = "Chave KMS para uso com o cluster EKS fiap-lanches"
  deletion_window_in_days = 7

  tags = {
    Name        = "fiap-eks-kms"
    Environment = "Production"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.3"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  vpc_id = "vpc-068207d590edc3748"
  subnet_ids = [
    "subnet-0cff870d98841b1f7",
    "subnet-03a3d01b444be36f9",
    "subnet-09668b48379dbd6c5"
  ]

  cluster_endpoint_public_access = true


  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.fiap_lanches_eks.arn
    resources        = ["secrets"]
  }

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

  kms_key_users = ["arn:aws:iam::211125342569:user/jamal"]

  # access_entries = {

  #   root = {
  #     principal_arn = "arn:aws:iam::211125342569:user/jamal"

  #     policy_associations = {

  #       view = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  #         access_scope = {
  #           namespaces = ["fiap-lanches", "default", "kube-system"]
  #           type       = "namespace"
  #         }
  #       }

  #       admin = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  #         access_scope = {
  #           namespaces = ["fiap-lanches", "default", "kube-system"]
  #           type       = "namespace"
  #         }
  #       }

  #       edit = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  #         access_scope = {
  #           namespaces = ["fiap-lanches", "default", "kube-system"]
  #           type       = "namespace"
  #         }
  #       }

  #       admin_cluster = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #         access_scope = {
  #           namespaces = ["fiap-lanches", "default", "kube-system"]
  #           type       = "namespace"
  #         }
  #       }
  #     }
  #   }
  # }

  depends_on = [aws_kms_key.fiap_lanches_eks]
}
