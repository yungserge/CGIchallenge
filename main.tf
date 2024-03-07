terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.94.0"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.26.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "cluster" {
  source                = "./modules/cluster/"
}

module "k8s" {
  source                = "./modules/k8s/"
  host                  = "${module.cluster.host}"
  client_certificate    = "${base64decode(module.cluster.client_certificate)}"
  client_key            = "${base64decode(module.cluster.client_key)}"
  cluster_ca_certificate= "${base64decode(module.cluster.cluster_ca_certificate)}"
}