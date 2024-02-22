variable "project_id" {
  description = "project id"
  default = "aqueous-glyph-302220"
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}