terraform {
  backend "s3" {
    bucket = "nixcfg-tfstate"
    key    = "anish-land/terraform.tfstate"
    region = "auto"

    endpoints = {
      s3 = "https://1aeefdcd08c221dbe83c20913cc21c50.r2.cloudflarestorage.com"
    }

    # r2 backend compat
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
