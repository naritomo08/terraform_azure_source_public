output "vm02-publicip" {
  value       = azurerm_public_ip.vm02.ip_address
  description = ""
}