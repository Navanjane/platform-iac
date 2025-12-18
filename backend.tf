terraform {
  backend "s3" {
    bucket       = "terraform-state-platform-iac"
    key          = "platform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
