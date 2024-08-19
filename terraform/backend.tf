terraform {
  backend "s3" {
    bucket         = "backend-terraform-94144"
    key            = "Jenkins/terraform.tfstate"
    region         = "ap-south-1" 
    encrypt        = true
  }
}
