variable "prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "location" {
  type        = string
  description = "Azure region for the network"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the network will be created"
}
