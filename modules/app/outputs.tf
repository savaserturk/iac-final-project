output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "redis_host" {
  value = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  value = azurerm_redis_cache.redis.ssl_port
}



