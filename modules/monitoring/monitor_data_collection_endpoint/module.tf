resource "azurerm_monitor_data_collection_endpoint" "mdce" {
  name                          = var.settings.name
  resource_group_name           = local.resource_group_name
  location                      = local.location
  kind                          = var.settings.kind
  public_network_access_enabled = try(var.settings.public_network_access_enabled, null)
  description                   = try(var.settings.description, null)
  tags                          = local.tags
}