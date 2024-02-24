variable "project_id" {
  description = "project id"
  default = ""
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "zone" {
  description = "region"
  default = "us-central1-b"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "cluster_name" {
  description = "name assinged to the cluster"
  default = "test-cluster"
}