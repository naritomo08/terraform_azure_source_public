data "terraform_remote_state" "rg" {
  backend = "azurerm"

  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstateuqrlr"
    container_name       = "tfstate"
    key                  = "resourcegroup.tfstate"
  }
}
