output "vm_identity_object_id" {
  value = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

output "vm_public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}