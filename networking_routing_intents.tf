resource "azapi_resource" "routing_intent" {
  for_each = local.networking.routing_intents

  type      = "Microsoft.Network/virtualHubs/routingIntent@2022-01-01"
  name      = each.value.name
  parent_id = can(each.value.virtual_hub.id) ? each.value.virtual_hub.id : local.combined_objects_virtual_hubs[try(each.value.virtual_hub.lz_key, local.client_config.landingzone_key)][each.value.virtual_hub.key].id
  body = jsonencode(
    {
      properties = {
        routingPolicies = [
          for key, value in each.value.next_hops : {
            name         = value.name
            destinations = value.destinations
            nextHop      = can(value.azurerm_firewall_id) ? value.azurerm_firewall_id : local.combined_objects_azurerm_firewalls[try(value.lz_key, local.client_config.landingzone_key)][value.key].id
          }
        ]
      }
    }
  )
}