terraform {
  required_version = "~> 0.12.7"
}

locals {
  cluster_node_count = 1
}

provider "google" {
  # Stay on 2.12 for now
  # https://github.com/terraform-providers/terraform-provider-google/issues/4276
  version = "~> 2.12.0"
  access_token = var.access_token
  project = var.project_id
  region = var.region
  zone = "${var.region}-a"
}

provider "google-beta" {
  version = "~> 2.12.0"
  access_token = var.access_token
  project = var.project_id
  region = var.region
  zone = "${var.region}-a"
}

data "google_project" "my_project" {
  project_id = var.project_id
}

resource "google_project_service" "googleapi_container" {
  service = "container.googleapis.com"
  disable_dependent_services = true
}

resource "google_container_cluster" "my_cluster" {
  name = "my-cluster"
  remove_default_node_pool = true
  initial_node_count = 1
  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
}

resource "google_container_node_pool" "my_node_pool" {
  name = "my-node-pool"
  cluster = google_container_cluster.my_cluster.name
  node_count = local.cluster_node_count

  node_config {
    preemptible = true
    machine_type = "n1-standard-2"
    # https://developers.google.com/identity/protocols/googlescopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_service_account" "my_service_account" {
  account_id = "my-service-account"
  display_name = "My Service Account"
}

resource "google_project_iam_binding" "service_account" {
  role = "roles/storage.admin"
  members = ["serviceAccount:${google_service_account.my_service_account.email}"]
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.my_service_account.name
}
