resource "azurerm_monitor_private_link_scoped_service" "service" {
  for_each = local.shared_services.monitor_private_link_scoped_services

  resource_group_name = can(each.value.resource_group.name) || can(each.value.resource_group_name) ? try(each.value.resource_group.name, each.value.resource_group_name) : local.combined_objects_resource_groups[try(each.value.resource_group.lz_key, local.client_config.landingzone_key)][each.value.resource_group.key].name
  scope_name          = local.combined_objects_monitor_private_link_scopes[try(each.value.monitor_private_link_scope.lz_key, local.client_config.landingzone_key)][each.value.monitor_private_link_scope.key].name
  name = coalesce(
    (each.value.resource_type == "log_analytics" ? local.combined_objects_log_analytics[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].name : null),
    (each.value.resource_type == "monitor_data_collection_endpoints" ? local.combined_objects_monitor_data_collection_endpoints[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].name : null),
    (each.value.resource_type == "azurerm_application_insights" ? local.combined_objects_application_insights[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].name : null)
  )
  linked_resource_id = coalesce(
    (each.value.resource_type == "log_analytics" ? local.combined_objects_log_analytics[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].id : null),
    (each.value.resource_type == "monitor_data_collection_endpoints" ? local.combined_objects_monitor_data_collection_endpoints[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].id : null),
    (each.value.resource_type == "azurerm_application_insights" ? local.combined_objects_application_insights[try(each.value.lz_key, local.client_config.landingzone_key)][each.value.key].id : null)
  )


  lifecycle {
    precondition {
      condition = can(each.value.resource_type) ? contains(
        [
          "log_analytics",
          "azurerm_application_insights",
          "monitor_data_collection_endpoints"
        ], each.value.resource_type
      ) : true
      error_message = format("Not supported value: '%s'. \nAdjust your configuration file with a supported value for var.monitor_private_link_scoped_services[x].resource_type: %s",
        each.value.resource_type,
        join(", ",
          [
            "log_analytics",
            "azurerm_application_insights",
            "monitor_data_collection_endpoints"
          ]
        )
      )
    }
  }
}