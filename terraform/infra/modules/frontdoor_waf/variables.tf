variable "backend_host" {}
variable "tags" {
  type = map(string)
}
variable "waf_name" {
  type        = string
  description = "Name of the Front Door WAF policy"
}
variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "location" {
  type        = string
  description = "Azure location"
}
variable "frontdoor_name" {
  type = string
}

variable "frontend_host" {
  type = string
}   
variable "frontend_endpoint_name" {
  description = "Frontend endpoint name"
  type        = string
}