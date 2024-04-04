output "subnet_public" {
  value       = azurerm_subnet.public.id
  description = ""
}

output "network_security_group_public" {
  value       = azurerm_network_security_group.public.name
  description = ""
}

output "subnet_private" {
  value       = azurerm_subnet.private.id
  description = ""
}
