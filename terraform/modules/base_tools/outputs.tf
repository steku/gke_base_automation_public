output "argocd_initial_password" {
  value = lookup(data.external.argocd_password.result, "podName")
}
