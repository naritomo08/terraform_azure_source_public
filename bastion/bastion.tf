resource "azurerm_public_ip" "pip_bastion" {
    name                = "pip-bas"
    location            = var.location
    resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_bastion_host" "host_bastion" {
    name                = "host-bas"
    location            = var.location
    resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
    sku                 = "Basic"
    #tunneling_enabled   = true

    ip_configuration {
        name                 = "vm_ip_configuration"
        subnet_id            = data.terraform_remote_state.network.outputs.subnet_bastion
        public_ip_address_id = azurerm_public_ip.pip_bastion.id
    }
}
