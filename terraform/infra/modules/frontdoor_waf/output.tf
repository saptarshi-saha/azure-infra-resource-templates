# output "frontdoor_id" {
#   value = azurerm_frontdoor_standard.fd.id
# }

output "waf_policy_id" {
  value = azurerm_cdn_frontdoor_firewall_policy.waf_policy.id
}
# output "frontdoor_endpoint" {
#   value = azurerm_frontdoor_standard.fd.frontend_endpoint[0].host_name
# }

