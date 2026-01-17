terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

variable "project_id" {
  description = "GCP project in which to manage resources."
  type        = string
  default     = "ohmyhack2025"
}

variable "region" {
  description = "Default region for the Google provider."
  type        = string
  default     = "us-central1"
}

variable "user_email" {
  description = "Email address of the user who will impersonate the gke-init-python service account."
  type        = string
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_service_account" "gke_init_python_sa" {
  account_id   = "gke-init-python"
  display_name = "gke-init-python"
}

resource "google_service_account" "secops_auth_sa" {
  account_id   = "secops-auth"
  display_name = "secops-auth"
}

resource "google_service_account_iam_member" "gke_init_python_token_creator" {
  service_account_id = google_service_account.gke_init_python_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${var.user_email}"
}

resource "google_service_account_iam_member" "secops_auth_token_creator" {
  service_account_id = google_service_account.secops_auth_sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.gke_init_python_sa.email}"
}
