terraform {
  cloud {
    hostname = "app.terraform.io"
    organization = "fiap-lanches-eks"
    token = "96YE6Nx1GXV68g.atlasv1.bVm5Kkh1mSdmqyWj2eh0WDkcO7n8i3QigH3LuiUfAA5A9SH6Dm3aUBRqzclCYBlycN8"

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
