output "argocd-initial-password" {
  value       = module.base_tools.argocd_initial_password
  description = "Initial password for Argo CD, should be changed once Argo is up"
}

output "connect-command" {
  value       = module.gke_cluster.connect_command
  description = "Get kubeconfig for cluster"
}

output "port-forward" {
  value       = "kubectl port-forward svc/argocd-server -n argocd 8080:443"
  description = "Forward port https://localhost:8080 to port 443 on argocd-server"
}

output "project-id" {
  value       = module.gcp_project.project_id
  description = "ID of the GCP Project"
}