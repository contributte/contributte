terraform {
  required_version = ">= 1.11.0"

  backend "s3" {
    key                         = "contributte.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.6.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "github" {
  token = var.github_token
  owner = "contributte"
}
