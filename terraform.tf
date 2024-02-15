terraform {
  backend "remote" {
    # hostname = "app.terraform.io"
    organization = "fiap-lanches-eks"
    token = "yXIpzz9YYQbGmw.atlasv1.pwoMBzZXZIqKnBf8jD0cxEjJTOM2KIZNzpSqdSVH6ZdJJ9d55nzPImuSbiWdDtf3DqA"

    workspaces {
      name = "fiap-lanches-workflow"
    }
  }

  required_providers {
    tfe = {
      version = "~> 0.52.0"
    }
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
