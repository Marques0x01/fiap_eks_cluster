# # Copyright (c) HashiCorp, Inc.
# # SPDX-License-Identifier: MPL-2.0

# provider "helm" {
#   kubernetes {
#     host                   = data.aws_eks_cluster.cluster.endpoint
#     cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#     exec {
#       api_version = "client.authentication.k8s.io/v1beta1"
#       args        = ["eks", "get-token", "--cluster-name", "education-eks-C2s7VqWP"]
#       command     = "aws"
#     }
#   }
# }

# resource "helm_release" "fiap-lanches" {
#   name = "fiap-lanches"

#   chart = "https://github.com/jonathansantoss/fiap-lanches-helm/releases/download/fiap-lanches-0.2.0/fiap-lanches-0.2.0.tgz"
# }
