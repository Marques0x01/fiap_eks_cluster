terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "fiap-lanches-eks"
    token = "AalvRrZ1ZcFuhg.atlasv1.tqc5pZJFkvjTWUXEgEemc29nNzCwIsjpPjNKNm3q0xu2C1NWBZim50S9Ptn8IhWERW4"

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
