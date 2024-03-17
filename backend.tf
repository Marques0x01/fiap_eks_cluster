terraform {
  backend "s3" {
    bucket         = "fiap-terraform-tfstates"
    key            = "eks_cluster/terraform.tfstate"
    region         = "sa-east-1"
    
  }
}
