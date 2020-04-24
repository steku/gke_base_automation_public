variable "project_id" {
  type        = string
  description = "Project to place cluster in"
}

variable "zone" {
  type        = string
  description = "zone to place cluster in"
}

variable "kubernetes_release_channel" {
  default     = "RAPID"
  type        = string
  description = "see https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels"
}

variable "machine_type" {
  default     = "n1-standard-4"
  type        = string
  description = "VM type"
}
variable "node_count" {
  default     = "2"
  type        = string
  description = "number of nodes"
}
variable "preemptible" {
  default     = true
  type        = bool
  description = "preemptable to save money"
}

variable "cluster_name" {
  type        = string
  description = "name of cluster"
}

variable "remove_default_node_pool" {
  type        = string
  default     = true
  description = "using default pool is considered insecure"
}

variable "module_depends_on" {
  default     = [""]
  type        = list
  description = "List of modules that must run before this one"
}