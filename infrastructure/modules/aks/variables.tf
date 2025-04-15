variable "cluster_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "location" {
  type        = string
  description = "Azure region to deploy resources"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where AKS cluster will be deployed"
}
variable "labelPrefix" {
  type        = string
  description = "Prefix label used for naming resources"
}

variable "region" {
  type        = string
  description = "Azure region to deploy resources"
}
variable "dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster"
}

variable "node_count" {
  type        = number
  description = "Fixed number of nodes (used in test environment)"
  default     = null
}

variable "min_count" {
  type        = number
  description = "Minimum number of nodes for autoscaling"
  default     = null
}

variable "max_count" {
  type        = number
  description = "Maximum number of nodes for autoscaling"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Version of Kubernetes to deploy"
}

# Add validation to prevent both strategies from being defined at once
locals {
  is_autoscaling = var.min_count != null && var.max_count != null
  is_fixed_size  = var.node_count != null
}

# Validate that only one node strategy is used
resource "null_resource" "validate_node_pool" {
  count = (local.is_autoscaling && local.is_fixed_size) ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'ERROR: You cannot set both node_count and autoscaling values (min_count/max_count) at the same time.' && exit 1"
  }
}

