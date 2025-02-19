terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"  # provider source location
      version = "~> 2.0"
    }
  }
}

# configure K8 provider
provider "kubernetes" {
  config_path    = "~/.kube/config"   # path to kubeconfig file
  config_context = "minikube"         # yse minikube context
}

variable "image_tag" {
  description = "The Docker image tag to deploy"
  type        = string
  default     = "api-infra:v2"
}

# create K8 deployment
resource "kubernetes_deployment" "api" {
  metadata {
    name = "api-deployment"
    labels = {
      app = "fastapi-app"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "fastapi-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "fastapi-app"
        }
      }

      spec {
        container {
          image = var.image_tag   # using image_tag variable
          name  = "fastapi-container"

          port {
            container_port = 8000
          }

          resources {
            limits = {
              cpu    = "500m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

# create K8 service
resource "kubernetes_service" "api" {
  metadata {
    name = "api-service"            # name of the service
  }

  spec {
    selector = {
      app = "fastapi-app"
    }

    port {
      port        = 8000
      target_port = 8000
    }

    type = "NodePort"
  }
}
