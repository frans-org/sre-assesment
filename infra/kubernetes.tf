module "web_app" {
    source = "../modules/web"
    depends_on = [ google_container_cluster.primary ]
}