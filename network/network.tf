# virtual_network

resource "azurerm_virtual_network" "virtualNetwork" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
  address_space       = var.network_address
}

# subnet

resource "azurerm_subnet" "public" {
  name                 = "Public"
  resource_group_name  = data.terraform_remote_state.rg.outputs.resource_group
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = var.public_address
}

resource "azurerm_subnet" "private" {
  name                 = "Private"
  resource_group_name  = data.terraform_remote_state.rg.outputs.resource_group
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = var.private_address
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.terraform_remote_state.rg.outputs.resource_group
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = var.bastion_address
}

# network_security_group(public)

resource "azurerm_network_security_group" "public" {
  name                = var.public-securitygroup
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
}

# PublicSubnetとNSGの関連付け

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.public.id
  network_security_group_id = azurerm_network_security_group.public.id
}

# network_security_group(private)

resource "azurerm_network_security_group" "private" {
  name                = var.private-securitygroup
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
}

# PrivateSubnetとNSGの関連付け

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}

# network_security_group(bastion)

resource "azurerm_network_security_group" "bastion" {
  name                = var.bastion-securitygroup
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
}

# BastionSubnetとNSGの関連付け

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
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
    network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_bastion
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
    network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_bastion
}

resource "azurerm_network_security_rule" "BastionRDPSSH" {
    name                       = "AllowPrivateVnetOutBound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["3389","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_bastion
}

resource "azurerm_network_security_rule" "BastionCloud" {
    name                       = "AllowAzureCloudOutBound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
    resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
    network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_bastion
}