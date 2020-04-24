
// Create a project, if you have an existing project, comment this module out
module "gcp_project" {
  source = "./modules/gcp_project"

  project_id_prefix   = var.project_id_prefix
  project_name_prefix = var.project_name_prefix
  billing_account     = var.billing_account
}

// Create the cluster, if you are using an existing project update the project_id and remove the module_depends_on line
module "gke_cluster" {
  source = "./modules/gke_cluster"

  zone         = var.zone
  cluster_name = var.cluster_name
  project_id   = module.gcp_project.project_id

  module_depends_on = [module.gcp_project]
}

// Install and confgure KES and Argo CD
module "base_tools" {
  source = "./modules/base_tools"

  vault_addr = var.vault_addr
  kubectx    = module.gke_cluster.kubectx

  module_depends_on = [module.gke_cluster]
}

// Setup the auth for K8s to authenticate to Vault
module "vault_config" {
  source = "./modules/vault_config"

  vault_addr       = var.vault_addr
  vault_token      = var.vault_token
  cluster_endpoint = "https://${module.gke_cluster.cluster_endpoint}"
  cluster_ca       = module.gke_cluster.cluster_ca
  kubectx          = module.gke_cluster.kubectx

  module_depends_on = [module.gke_cluster]
}