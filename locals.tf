locals {
rg{
  name = "example"
  location = "centralus"
}
  acr = {
    name                = "newenvacrreg"
    resource_group_name = "example"
    location            = "centralus"
    sku                 = "Basic"
    admin_enabled       = false
  }

  aks = {
    name                      = "newenv-aks"
    location                  = "centralus"
    resource_group_name       = "example"
    dns_prefix                = "newenv-aks"
    kubernetes_version        = "1.20.9"
    private_cluster_enabled   = false
    role_based_access_control = true

    default_node_pool = {
      name                 = "default"
      orchestrator_version = "1.20.9"
      node_count           = 2
      vm_size              = "Standard_B2s"
      os_disk_size_gb      = 100
      type                 = "VirtualMachineScaleSets"
      availability_zones   = ["1", "2"]
      min_count            = 2
      max_count            = 20
      max_pods             = 50
      enable_auto_scaling  = true
    }
    service_principal = {
      client_id     = "xxx"
      client_secret = "xxx"
    }

  }
  node_pool = {
    name                 = "default"
    orchestrator_version = "1.20.9"
    node_count           = 2
    vm_size              = "Standard_B2s"
    os_disk_size_gb      = 100
    availability_zones   = ["1", "2"]
    min_count            = 2
    max_count            = 20
    max_pods             = 50
    enable_auto_scaling  = true

  }

}
