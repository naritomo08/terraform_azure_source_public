# network_interface(vm03)

resource "azurerm_network_interface" "vm03" {
  name                = var.vm03-network_interface_name
  location            = var.location
  resource_group_name = data.terraform_remote_state.rg.outputs.resource_group
  ip_configuration {
    name                          = "testconfiguration3"
    subnet_id                     = data.terraform_remote_state.network.outputs.subnet_private
    private_ip_address_allocation = "Dynamic"
  }
}

# virtual_machine(vm03)

resource "azurerm_virtual_machine" "vm03" {
  name                  = var.vm03-vmname
  location              = var.location
  resource_group_name   = data.terraform_remote_state.rg.outputs.resource_group
  network_interface_ids = [azurerm_network_interface.vm03.id]
  vm_size               = "Standard_DS1_v2"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = var.vm03-storagename
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm03-hostname
    admin_username = var.vm03-username
    admin_password = var.vm03-password
  }
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
}
