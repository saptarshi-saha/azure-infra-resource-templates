variable "app_service_name" {}
variable "resource_group_name" {}
variable "location" {}
variable "tags" {
  type = map(string)
}

variable "app_service_id" {
  type        = string
  description = "Resource ID of the app service to monitor"
}

/* variable "log_analytics_workspace_id" {
  type        = string
  description = "Log Analytics workspace ID for diagnostic logs"
} */
