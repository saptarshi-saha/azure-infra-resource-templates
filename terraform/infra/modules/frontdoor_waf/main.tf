resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "${var.frontdoor_name}-profile"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
  name                           = "${var.frontdoor_name}-origin"
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_profile.fd_profile.id
  host_name                      = var.backend_host
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_custom_domain" "fd_custom_domain" {
  name                        = "${var.frontdoor_name}-custom-domain"
  cdn_frontdoor_profile_id    = azurerm_cdn_frontdoor_profile.fd_profile.id
  host_name                   = var.frontend_host

  tls {
    certificate_type = "ManagedCertificate"
  }
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf_policy" {
  name                = var.waf_name
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"
  mode                = "Prevention"

  custom_rule {
    name     = "${var.waf_name}-custom-rule"
    action   = "Block"
    priority = 1
    type     = "MatchRule"

    match_condition {
      match_variable = "RequestMethod"
      match_values   = ["POST"]
      operator       = "Equal"
    }
  }
}
# resource "azurerm_cdn_frontdoor" "fd" {
#   name                = var.frontdoor_name
#   resource_group_name = var.resource_group_name
#   profile_id          = azurerm_cdn_frontdoor_profile.fd_profile.id
#   enforce_backend_pools_certificate_name_check = true

#   frontend_endpoint {
#     name      = var.frontend_endpoint_name
#     host_name = azurerm_cdn_frontdoor_custom_domain.fd_custom_domain.host_name
#   }

#   origin_group {
#     name = "${var.frontdoor_name}-origin-group"

#     origin {
#       id = azurerm_cdn_frontdoor_origin.fd_origin.id
#     }

#     health_probe_settings {
#       probe_path        = "/"
#       probe_protocol    = "Https"
#       probe_interval_in_seconds = 120
#     }

#     load_balancing_settings {
#       sample_size            = 4
#       successful_samples_required = 2
#       additional_latency_milliseconds = 0
#     }
#   }

#   routing_rule {
#     name               = "${var.frontdoor_name}-routing-rule"
#     accepted_protocols = ["Https"]
#     patterns_to_match  = ["/*"]
#     frontend_endpoints = [azurerm_cdn_frontdoor.fd.frontend_endpoint[0].id]
#     origin_group       = azurerm_cdn_frontdoor.fd.origin_group[0].id
#   }

#   waf_policy_link {
#     id = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id
#   }

#   tags = var.tags
# }