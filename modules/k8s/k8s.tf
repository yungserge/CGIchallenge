provider "kubernetes" {
    host                   =  var.host
    client_certificate     =  var.client_certificate
    client_key             =  var.client_key
    cluster_ca_certificate =  var.cluster_ca_certificate
}

resource "kubernetes_deployment" "webserver" {
  metadata {
    name = "web-server"
    labels = {
      app = "web-server"
    }
  }

  spec {
    replicas = 4

    selector {
      match_labels = {
        app = "web-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "web-server"
        }
      }

      spec {
        container {
          image = "yungserge/my-web-server:latest"
          name  = "hello-world"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "5m"
              memory = "512Mi"
            }
            requests = {
              cpu    = "5m"
              memory = "50Mi"
            }
          }

        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "web-server"
  }

  spec {
    selector = {
      app = "web-server"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"  # Expose service as a LoadBalancer
  }
}

resource "kubernetes_horizontal_pod_autoscaler_v2" "webserver_autoscaler" {
  metadata {
    name = "webserver-autoscaler"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "web-server"  # Name of your NGINX deployment
    }

    min_replicas = 3
    max_replicas = 10

    metric {
      type = "Resource"
      resource {
        name  = "cpu"
        target {
          type                = "Utilization"
          average_utilization = 60  # Target CPU utilization percentage
        }
      }
    }
  }
}