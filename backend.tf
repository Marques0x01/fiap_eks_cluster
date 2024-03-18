terraform {
  backend "s3" {
    bucket         = "tfstate-fiap"
    key            = "eks_cluster/terraform.tfstate"
    region         = "us-east-1"
    
  }
}
