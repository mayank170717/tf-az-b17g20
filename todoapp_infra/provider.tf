terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
    backend "azurerm" {
    resource_group_name = "404-todoapp"
    storage_account_name = "404storageaccount"
    container_name       = "tfstate"
    key                  = "404.tfstate"
  }

}

provider "azurerm" {
  features {}
  subscription_id = "a1a28045-a62e-4eb2-af69-c05bca1267b0"
}