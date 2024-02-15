terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "fiap-eks"
    token = "uknlltsqp5ne6q.atlasv1.b4zk1zup1g58jddzrxqxqtbgbrycbwusxdrm8oyg0dvq071wqvefsyxdxvuhlvwztys"

    workspaces {
      name = "fiap-lanches-terraform-eks-gitactions"
    }
  }

  #  backend "remote" {
  #   token = "uknlltsqp5ne6q.atlasv1.b4zk1zup1g58jddzrxqxqtbgbrycbwusxdrm8oyg0dvq071wqvefsyxdxvuhlvwztys"
  #  }

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
