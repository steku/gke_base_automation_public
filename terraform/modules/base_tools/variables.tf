variable "kes_namespace" {
  default     = "kes"
  type        = string
  description = "namespace to install KES in"
}

variable "vault_addr" {
  type        = string
  description = "Address of external Vault server"
}

variable "module_depends_on" {
  default     = [""]
  description = "Modules that are required to run before this module does"
  type        = list
}

variable "kubectx" {
  type        = string
  description = "Context of kubeconfig to parse for cluster"
}