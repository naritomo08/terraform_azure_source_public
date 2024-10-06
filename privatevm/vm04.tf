# azurerm_network_security_rule(public RDP Accept)
resource "azurerm_network_security_rule" "PrivateSSHInbound" {
  name                        = "SSH"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
  network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_private
}

# network_interface(vm04)

resource "azurerm_network_interface" "vm04" {
  name                = var.vm04-network_interface_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
  ip_configuration {
    name                          = "testconfiguration4"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_private
    private_ip_address_allocation = "Dynamic"
  }
}

# virtual_machine(vm04)

resource "azurerm_virtual_machine" "vm04" {
  name                  = var.vm04-vmname
  location              = var.location
  resource_group_name   = data.terraform_remote_state.rg.outputs.resource_group
  network_interface_ids = [azurerm_network_interface.vm04.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.vm04-storagename
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm04-hostname
    admin_username = var.vm04-username
    admin_password = var.vm04-password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}