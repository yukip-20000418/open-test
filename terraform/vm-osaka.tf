# service account
resource "google_service_account" "osaka" {
  account_id = "osaka-account"
  depends_on = [google_project_service.iam]
}

# compute instance
resource "google_compute_instance" "osaka" {
  name = "osaka"
  tags = ["ssh"]

  machine_type = "e2-medium"
  zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  hostname = "osaka.chottodake.dev"

  service_account {
    email  = google_service_account.osaka.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    subnetwork = google_compute_subnetwork.osaka.id
    access_config {
    }
  }
}
