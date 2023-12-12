resource "azurerm_resource_group" "azlab" {
  name     = "azlab"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "azaks" {
  name                = "azaks"
  location            = azurerm_resource_group.azlab.location
  resource_group_name = azurerm_resource_group.azlab.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    node_count = 2
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.azaks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.azaks.kube_config_raw

  sensitive = true
}