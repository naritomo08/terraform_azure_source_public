data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    storage_account_name = "tfstateuqrlr"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}
