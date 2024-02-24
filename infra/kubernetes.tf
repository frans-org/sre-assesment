module "web_app" {
    source = "../modules/web"
    project_id = var.project_id
    depends_on = [ google_container_cluster.primary ]
}