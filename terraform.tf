terraform {
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "fiap-lanches-eks"
  #   # token = "6iNeRcXFEg5Dtg.atlasv1.aiL79N5mBtm3EmkNucGcz3Iz0EztessuHCxPTiYVovNEgcMmyDpZmRULL2QSLRKeGE4"

  #   workspaces {
  #     name = "fiap-lanches-workflow"
  #   }
  # }

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

terraform {
  required_providers {
    terraform = {
        terraform = {
        source = "hashicorp/terraform"
        version = "~> 1.7.3"
      }
    }
  }
  credentials {
    token = "2fyiGjtppZ3vcQ.atlasv1.jm4EQUCCYyZqxzCKe8YsLYm7cwVqKfrCW5Vyr5VP5A3BSIdvQE4Y3b9v6rG1mqtt074"
  }
}