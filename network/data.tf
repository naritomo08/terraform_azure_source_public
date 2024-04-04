data "terraform_remote_state" "rg" {
  backend = "azurerm"

  config = {
    storage_account_name = "tfstateuqrlr"
    container_name       = "tfstate"
    key                  = "resourcegroup.tfstate"
  }
}
