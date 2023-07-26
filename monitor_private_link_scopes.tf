module "monitor_private_link_scopes" {
  source   = "./modules/monitoring/monitor_private_link_scope"
  for_each = local.shared_services.monitor_private_link_scopes

  client_config   = local.client_config
  global_settings = local.global_settings
  settings        = each.value

  location            = can(each.value.region) ? local.global_settings.regions[each.value.region] : null
  resource_group      = local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][each.value.resource_group.key]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : null

  private_dns     = can(each.value.private_endpoints) ? local.combined_objects_private_dns : null
  vnets           = can(each.value.private_endpoints) ? local.combined_objects_networking : null
  virtual_subnets = can(each.value.private_endpoints) ? local.combined_objects_virtual_subnets : null
}

output "monitor_private_link_scopes" {
  value = module.monitor_private_link_scopes
}
