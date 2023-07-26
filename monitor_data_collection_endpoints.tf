module "monitor_data_collection_endpoints" {
  source   = "./modules/monitoring/monitor_data_collection_endpoint"
  for_each = local.shared_services.monitor_data_collection_endpoints

  client_config   = local.client_config
  global_settings = local.global_settings
  settings        = each.value

  resource_group      = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? null : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][each.value.resource_group.key]
  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][each.value.resource_group.key].name
  location            = can(local.global_settings.regions[each.value.region]) ? local.global_settings.regions[each.value.region] : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][try(each.value.resource_group.key, each.value.resource_group_key)].location
}

output "monitor_data_collection_endpoints" {
  value = module.monitor_data_collection_endpoints
}