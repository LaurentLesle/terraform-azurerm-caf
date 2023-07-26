variable "global_settings" {
  description = "Global settings object (see module README.md)"
}
variable "client_config" {
  description = "Client configuration object (see module README.md)."
}
variable "settings" {
  description = "(Required) Used to handle passthrough paramenters."
}
variable "resource_group" {
  description = " The Resource Group object."
}
variable "resource_group_name" {
  description = "The name of the resource group."
  default     = null
}
variable "location" {
  description = "Override of the location. Default to the resource group location if not set."
  default     = null
}
variable "private_dns" {
  description = "(Optional) Private DNS zones to record the private ip of the private endpoint."
  default     = {}
}
variable "vnets" {
  default = {}
}
variable "virtual_subnets" {
  default = {}
}