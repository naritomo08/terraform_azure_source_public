resource "azurerm_network_security_rule" "PublicSSH" {
  name                        = "SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = local.allowed_cidr
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.terraform_remote_state.network.outputs.resource_group
  network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_public
}

# public_ip(vm02)

resource "azurerm_public_ip" "vm02" {
  name                = var.vm02-publicip
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group
  allocation_method   = "Static"
}

# network_interface(vm02)

resource "azurerm_network_interface" "vm02" {
  name                = var.vm02-network_interface_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group
  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_public
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm02.id
  }
}

# virtual_machine(vm02)

resource "azurerm_virtual_machine" "vm02" {
  name                  = var.vm02-vmname
  location              = var.location
  resource_group_name   = data.terraform_remote_state.network.outputs.resource_group
  network_interface_ids = [azurerm_network_interface.vm02.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.vm02-storagename
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm02-hostname
    admin_username = var.vm02-username
    admin_password = var.vm02-password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}