resource "azurerm_resource_group" "sergey_rg" {
  name     = "sergey_rg"
  location = "West Europe"

  tags = {
    author = "Sergey"
    purpose  = "Challenge"
  }
}

resource "azurerm_kubernetes_cluster" "cgi-k8s" {
  name                = "cgi-k8s"
  location            = azurerm_resource_group.sergey_rg.location
  resource_group_name = azurerm_resource_group.sergey_rg.name
  dns_prefix          = "CGIaks"

  default_node_pool {
    name       = "worker"
    node_count = 3
    vm_size    = "Standard_DS4_v2"
    temporary_name_for_rotation = "tempnode"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    author = "Sergey"
    purpose  = "Challenge"
  }
}
