resource "azurerm_subnet" "bastion" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = data.terraform_remote_state.rg.outputs.resource_group
    virtual_network_name = data.terraform_remote_state.network.outputs.virtual_network
    address_prefixes     = var.bastion_address
}

# network_security_group(bastion)

resource "azurerm_network_security_group" "bastion" {
    name                = var.bastion-securitygroup
    location            = var.location
    resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
}

# azurerm_network_security_rule(Bastion RDP Accept)
resource "azurerm_network_security_rule" "BastionGateway" {
    name                       = "AllowGatewayInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "BastionInternet" {
    name                       = "AllowInternetInBound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "BastionRDPSSH" {
    name                       = "AllowPrivateVnetOutBound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["3389","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "BastionCloud" {
    name                       = "AllowAzureCloudOutBound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = azurerm_network_security_group.bastion.name
}

# BastionSubnetとNSGの関連付け

resource "azurerm_subnet_network_security_group_association" "bastion" {
    subnet_id                 = azurerm_subnet.bastion.id
    network_security_group_id = azurerm_network_security_group.bastion.id
    depends_on = [
        azurerm_subnet.bastion,
        azurerm_network_security_group.bastion,
    ]
}
