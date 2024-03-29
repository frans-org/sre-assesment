resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "sre-nginx"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "eu.gcr.io/${var.project_id}/app"# e.g, "nginx:1.7.8"
          name  = "example"
          #command = [ "/bin/sh", "-c", "echo 'Hello lineten' > /usr/share/nginx/html/index.html"]
          port {
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    session_affinity = "ClientIP"
    port {
      port        = 8080
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "web_app_endpoint" {
  value = kubernetes_service.example.status.0.load_balancer.0.ingress.0.hostname
}