// terraform hack to make this module wait until prerequisite modules are complete
resource "null_resource" "module_depends_on" {
  triggers = {
    value = "${length(var.module_depends_on)}"
  }
}

// GKE cluster
resource "google_container_cluster" "demo" {
  provider   = google-beta
  name       = var.cluster_name
  location   = var.zone
  project    = var.project_id
  depends_on = [null_resource.module_depends_on]

  remove_default_node_pool = var.remove_default_node_pool
  initial_node_count       = 1

  release_channel {
    channel = var.kubernetes_release_channel
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

// GKE node pool
resource "google_container_node_pool" "demo_nodes" {
  name       = var.cluster_name
  project    = var.project_id
  location   = var.zone
  cluster    = google_container_cluster.demo.name
  node_count = var.node_count

  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/compute.readonly",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

// Get cluster credentials so we can perform tasks on it
resource "null_resource" "get-demo-credentials" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}"
  }
  depends_on = [google_container_node_pool.demo_nodes]
}
