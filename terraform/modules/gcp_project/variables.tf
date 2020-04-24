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

