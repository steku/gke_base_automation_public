variable "vault_addr" {
  type        = string
  description = "address of vault for VAULT_ADDR env varaiable"
}
variable "vault_token" {
  type        = string
  description = "Token with access to setup authentication endpoint and policies"
}

variable "kes_service_account" {
  default     = ["kes-kubernetes-external-secrets"]
  type        = list
  description = "Service account created by the KES installation, used for auth on Vault"
}

variable "token_policies" {
  default     = ["kes"]
  type        = list
  description = "Name of policy to create and assigne to the Vault role"
}

variable "vault_role_name" {
  default     = "kes"
  type        = string
  description = "Name of Vault KES will used when getting secrets"
}

variable "vault_auth_path" {
  default     = "kes"
  type        = string
  description = "Path to enable the Kubernetes Auth in Vault"
}

variable "kubectx" {
  description = "Context of kubeconfig to parse for cluster"
  type        = string
}

variable "vault_kes_path" {
  type        = string
  default     = "kes/data/*"
  description = "path where secrets exist in Vault, used for policy"
}

variable "kes_namespace" {
  type        = string
  default     = "kes"
  description = "namespace for Kubrernetes external secrets"
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for Vault auth"
}

variable "cluster_ca" {
  type        = string
  description = "CA certificate of cluster"
}

variable "module_depends_on" {
  default     = [""]
  type        = list
  description = "List of modules that must run before this one"
}