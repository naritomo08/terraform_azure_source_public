data "terraform_remote_state" "rg" {
  backend = "azurerm"

  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateilswl"
    container_name       = "tfstate"
    key                  = "resourcegroup.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateilswl"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}
