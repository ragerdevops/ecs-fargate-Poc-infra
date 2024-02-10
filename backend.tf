terraform {
  backend "s3" {
    bucket         = "bucket-s3-store"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
  }
}
