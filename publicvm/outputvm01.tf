output "vm01-publicip" {
  value       = azurerm_public_ip.vm01.ip_address
  description = ""
}