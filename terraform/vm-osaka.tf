# service account
resource "google_service_account" "osaka" {
  account_id = "osaka-account"
  depends_on = [google_project_service.iam]
}

# compute instance
resource "google_compute_instance" "osaka" {
  name = "osaka"
  tags = ["ssh", "debug"]

  machine_type = "e2-medium"
  zone         = "asia-northeast2-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2204-jammy-v20230428"
      size  = "10"
      type  = "pd-balanced"
    }
  }

  metadata_startup_script = file("./init-vm.sh")

  metadata = {
    enable_oslogin = "false"
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
