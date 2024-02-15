terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "fiap-eks"
    token = "fUzncTgw9lc72g.atlasv1.J2w2G3CnPQFtUyPNsb8t8Klgld6205AVlmA842fm3HnW48B4kEFz7Md2n94u9q41O3U"

    workspaces {
      name = "fiap-lanches-terraform-eks-gitactions"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.12.1"
    }
  }

    required_version = ">= 1.3"
}
