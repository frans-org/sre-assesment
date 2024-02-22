terraform {
  required_version = ">= 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.74.0"
    }
    helm = {
       source  = "hashicorp/helm"
       version = ">= 2.1.0"
    }    
  }
  backend "gcs" { 
      bucket  = "tf-000-bucket"
      prefix  = "state"
    }
}