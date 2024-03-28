output "vm04-privateip" {
  value       = azurerm_network_interface.vm04.private_ip_address
  description = ""
}