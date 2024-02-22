# # # Copyright (c) HashiCorp, Inc.
# # # SPDX-License-Identifier: MPL-2.0


provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", "fiap-lanches-eks-cWTzWOQb"]
      command     = "aws"
    }
  }
}

resource "helm_release" "fiap-lanches" {
  namespace = "fiap-lanches"
  create_namespace = true
  name       = "fiap-lanches"
  repository = "https://gitlab.com/api/v4/projects/55019864/packages/helm/stable"
  chart      = "fiap-lanches"
  version    = "v0.3.0"

    set {
    name  = "cluster.enabled"
    value = "true"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }
}

resource "helm_release" "metric-server" {
  name       = "metric-server"
  repository = "https://charts.bitnami.com/bitnami" 
  chart      = "metrics-server"
  namespace = "kube-system"
  set {
    name  = "apiService.create"
    value = "true"
  }
}