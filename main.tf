provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg"{
  name                = local.rg.name
  location            = local.rg.location
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr.name
  resource_group_name = local.acr.resource_group_name
  location            = local.acr.location
  sku                 = local.acr.sku
  admin_enabled       = local.acr.admin_enabled
  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_kubernetes_cluster" "cluster1" {
  name                    = local.aks.name
  location                = local.aks.location
  resource_group_name     = local.aks.resource_group_name
  dns_prefix              = local.aks.dns_prefix
  kubernetes_version      = local.aks.kubernetes_version
  private_cluster_enabled = local.aks.private_cluster_enabled

  default_node_pool {
    orchestrator_version = local.aks.default_node_pool.orchestrator_version
    name                 = local.aks.default_node_pool.name
    node_count           = local.aks.default_node_pool.node_count
    vm_size              = local.aks.default_node_pool.vm_size
    os_disk_size_gb      = local.aks.default_node_pool.os_disk_size_gb
    type                 = local.aks.default_node_pool.type
    availability_zones   = local.aks.default_node_pool.availability_zones
    min_count            = local.aks.default_node_pool.min_count
    max_count            = local.aks.default_node_pool.max_count
    max_pods             = local.aks.default_node_pool.max_pods
    enable_auto_scaling  = local.aks.default_node_pool.enable_auto_scaling
  }

  service_principal {
    client_id     = local.aks.service_principal.client_id
    client_secret = local.aks.service_principal.client_secret
  }

  role_based_access_control {
    enabled = local.aks.role_based_access_control
  }

  tags = {
    Environment = "Development"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "node" {
  name                  = local.node_pool.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.cluster1.id
  orchestrator_version  = local.node_pool.orchestrator_version
  vm_size               = local.node_pool.vm_size
  node_count            = local.node_pool.node_count
  os_disk_size_gb       = local.node_pool.os_disk_size_gb
  availability_zones    = local.node_pool.availability_zones
  enable_auto_scaling   = local.node_pool.enable_auto_scaling
  min_count             = local.node_pool.min_count
  max_count             = local.node_pool.max_count
  max_pods              = local.node_pool.max_pods
}

resource "azurerm_role_assignment" "allow_ACR" {
  principal_id         = azurerm_kubernetes_cluster.cluster1.kubelet_identity.0.object_id
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
}

