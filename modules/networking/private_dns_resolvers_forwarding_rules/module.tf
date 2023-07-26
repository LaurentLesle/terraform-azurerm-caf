data "azurecaf_name" "pvtdnsrfr" {
  name          = var.settings.name
  resource_type = "azurerm_private_dns_resolver_forwarding_rule"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = can(var.settings.global_settings.passthrough) ? var.settings.global_settings.passthrough : var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug

}


resource "azurerm_private_dns_resolver_forwarding_rule" "pvt_dns_resolver_forwarding_rule" {
  name                      = data.azurecaf_name.pvtdnsrfr.result
  dns_forwarding_ruleset_id = var.dns_forwarding_ruleset_id
  domain_name               = var.settings.domain_name
  enabled                   = try(var.settings.enabled, null)
  metadata                  = try(var.settings.metadata, {})

  dynamic "target_dns_servers" {
    for_each = {
      for key, value in var.settings.target_dns_servers : key => value
      if can(value.ip_address)
    }
    content {
      ip_address = target_dns_servers.value.ip_address
      port       = try(target_dns_servers.value.port, 53)
    }
  }

  dynamic "target_dns_servers" {
    for_each = try(var.settings.target_dns_servers.private_dns_resolver_inbound_endpoints, {})

    content {
      ip_address = var.remote_objects.private_dns_resolver_inbound_endpoints[try(target_dns_servers.value.lz_key, var.client_config.landingzone_key)][target_dns_servers.value.key].ip_configurations[target_dns_servers.value.interface_index].private_ip_address
      port       = try(target_dns_servers.value.port, 53)
    }
  }


}

