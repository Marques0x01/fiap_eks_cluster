# # # Copyright (c) HashiCorp, Inc.
# # # SPDX-License-Identifier: MPL-2.0

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "fiap-lanches-eks"]
      command     = "aws"
    }
  }
  registry {
    url      = "oci://${data.aws_ecr_repository.service.repository_url}"
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

resource "helm_release" "fiap-lanches" {
  namespace        = "fiap-lanches"
  force_update     = true
  create_namespace = true
  name             = "fiap-lanches"
  repository       = replace("oci://${data.aws_ecr_repository.service.repository_url}", "/fiap-lanches", "")
  chart            = "fiap-lanches"
  version          = "0.3.0"
  recreate_pods    = true

  set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }
}

# resource "helm_release" "metric-server" {
#   name       = "metric-server"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
#   set {
#     name  = "apiService.create"
#     value = "true"
#   }
# }
