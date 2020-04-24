output "kubectx" {
  value       = "gke_${google_container_cluster.demo.project}_${google_container_node_pool.demo_nodes.location}_${google_container_cluster.demo.name}"
  description = "kubectl context name"
}

output "cluster_endpoint" {
  value       = google_container_cluster.demo.endpoint
  description = "Endpoint of cluster, used as a placeholder to order modules"
}

output "cluster_ca" {
  value       = google_container_cluster.demo.master_auth.0.cluster_ca_certificate
  description = "ca certificate of cluster"
}

output "connect_command" {
  value       = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${var.zone} --project ${var.project_id}"
  description = "Get kubeconfig for cluster"
}