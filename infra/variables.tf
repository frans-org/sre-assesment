variable "project_id" {
  description = "project id"
  #default = "aqueous-glyph-302220"
}

variable "region" {
  description = "region"
  default = "europe-west2"
}

variable "zone" {
  description = "region"
  default = "europe-west2-a"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "cluster_name" {
  description = "name assinged to the cluster"
  default = "test-cluster"
}