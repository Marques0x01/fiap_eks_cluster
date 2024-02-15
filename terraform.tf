terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "fiap-lanches-eks"
    token = "m1Kn3hZYRAxbsA.atlasv1.qoGKdCwyS4vDVstpZNFKacbSOyWrq740cds11AnGv1PJrp5Z2yG1xoIydOXgkx4zuOY"

    workspaces {
      name = "fiap-lanches-workflow"
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
