resource "random_id" "project_suffix" {
  byte_length = "4"
}

resource "google_project" "demo" {
  name            = "${var.project_name_prefix}-${random_id.project_suffix.hex}"
  project_id      = "${var.project_id_prefix}-${random_id.project_suffix.hex}"
  billing_account = var.billing_account
}

// Enable GKE API
resource "google_project_service" "gke" {
  project = google_project.demo.project_id
  service = "container.googleapis.com"

  disable_dependent_services = true
}
