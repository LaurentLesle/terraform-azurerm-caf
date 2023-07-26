resource "azurerm_monitor_private_link_scope" "ampls" {

  name                = var.settings.name
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

output "id" {
  value = azurerm_monitor_private_link_scope.ampls.id
}
output "name" {
  value = azurerm_monitor_private_link_scope.ampls.name
}