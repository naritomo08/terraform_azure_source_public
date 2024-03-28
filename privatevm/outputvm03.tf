output "vm03-privateip" {
  value       = azurerm_network_interface.vm03.private_ip_address
  description = ""
}