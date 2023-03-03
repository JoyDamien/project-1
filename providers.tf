# providers.tf

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.45.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "2.36.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "4.56.0"
    }
  }
  required_version = "~>1.3,9"
}

provider "azurerm" {
  # Configuration options
  features {
    
  }
}

provider "azuread" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  region = “us-east-1"
}