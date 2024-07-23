resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "confi-rg"
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = azurerm_resource_group.rg.location
  name                = "aks-cluster"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akscluster"
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename = "/home/s6confidence/.kube/config"
}