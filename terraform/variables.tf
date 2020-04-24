// project variables
variable "project_name_prefix" {
  default     = "demo"
  type        = string
  description = "This string will be appended with a random suffix to create a unique project name"
}

variable "project_id_prefix" {
  default     = "anyname-here"
  type        = string
  description = "This string will be appended with a random suffix to create a unique project ID"
}

variable "billing_account" {
  default     = ""
  type        = string
  description = "GCP Billing Account ID"
}

// gke variables
variable "zone" {
  default     = "northamerica-northeast1-c"
  type        = string
  description = "GCP zone to place kubernetes cluster in"
}

variable "cluster_name" {
  default     = "demo"
  description = "Name of cluster to create on GKE"
  type        = string
}

// base variables
variable "vault_addr" {
  type        = string
  description = "Address of Vault server"
}

variable "vault_token" {
  type        = string
  description = "Token used to sign into Vault. Recommended to use the TF_VAR_vault_token environment variable for this"
}
