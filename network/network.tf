# resource_group

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# virtual_network

resource "azurerm_virtual_network" "virtualNetwork" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.network_address
}

# subnet

resource "azurerm_subnet" "public" {
  name                 = "Public"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = var.public_address
}

resource "azurerm_subnet" "private" {
  name                 = "Private"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefixes     = var.private_address
}

# network_security_group(public)

resource "azurerm_network_security_group" "public" {
  name                = var.public-securitygroup
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
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
  resource_group_name = azurerm_resource_group.resource_group.name
}

# PrivateSubnetとNSGの関連付け

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.private.id
  network_security_group_id = azurerm_network_security_group.private.id
}