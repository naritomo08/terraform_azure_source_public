# azurerm_network_security_rule(public RDP Accept)
resource "azurerm_network_security_rule" "PublicRDP" {
  name                        = "RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = local.allowed_cidr
  destination_address_prefix  = "VirtualNetwork"
  resource_group_name         = data.terraform_remote_state.rg.outputs.resource_group
  network_security_group_name = data.terraform_remote_state.network.outputs.network_security_group_public
}

# public_ip(vm01)

resource "azurerm_public_ip" "vm01" {
  name                = var.vm01-publicip
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
  allocation_method   = "Static"
}

# network_interface(vm01)

resource "azurerm_network_interface" "vm01" {
  name                = var.vm01-network_interface_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_public
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm01.id
  }
}

# virtual_machine(vm01)

resource "azurerm_virtual_machine" "vm01" {
  name                  = var.vm01-vmname
  location              = var.location
  resource_group_name   = data.terraform_remote_state.rg.outputs.resource_group
  network_interface_ids = [azurerm_network_interface.vm01.id]
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.vm01-storagename
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm01-hostname
    admin_username = var.vm01-username
    admin_password = var.vm01-password
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}
