# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = var.zone
  version_prefix = "1.27."
}

resource "google_container_cluster" "primary" {
  name     = "${var.cluster_name}-gke"
  location = var.region
  node_locations = [ var.zone ]
  deletion_protection = false
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.region
  node_locations = [ var.zone ]
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.gke_num_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    service_account = "project-service-account@${var.project_id}.iam.gserviceaccount.com"
    disk_size_gb = 50
    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.cluster_name}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# resource "google_service_account" "sa" {
#   account_id   = "project-service-account"
#   display_name = "Workload Service Account"
# }

# resource "google_service_account_iam_member" "workload-perms" {
#   service_account_id = google_service_account.sa.name
#   role               = "roles/iam.serviceAccountUser"
#   member             = "serviceAccount:${google_service_account.sa.email}"
# }