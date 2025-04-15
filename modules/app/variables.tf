variable "name_prefix" {
  type        = string
  description = "Prefix for resource names"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "region" {
  type        = string
  description = "Azure region for deployment"
}

variable "labelPrefix" {
  type        = string
  description = "Prefix for resource naming labels"
}


variable "aks_kubeconfig_raw" {
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
}