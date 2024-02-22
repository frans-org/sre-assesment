# This fetches a new token, which will expire in 1 hour.
data "google_client_config" "provider" {
    depends_on = [ google_container_cluster.primary ]
}

# Defer reading the cluster data until the GKE cluster exists.
data "google_container_cluster" "primary" {
  name = "${var.project_id}-gke"
  depends_on = [google_container_cluster.primary]
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}