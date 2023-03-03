# output.tf

output "azure-vm-id" {
  description = "ID of the Azure virtual machine created"
  value = azurerm_virtual_machine.azure-vm.id
}

output "azure-sa-primary-location" {
  description = "primary location of the azure storage account"
  value = azurerm_storage_account.azure-sa.primary_location
}