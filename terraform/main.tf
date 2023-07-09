# provider
provider "google" {
  project = "dev-chottodake-open-test"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

# terraform
terraform {
  backend "gcs" {
    bucket = "test.open.chottodake.dev"
    prefix = "terraform"
  }
}

# service
resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "compute" {
  service    = "compute.googleapis.com"
  depends_on = [google_project_service.cloudresourcemanager]
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
}

# network
resource "google_compute_network" "open-test" {
  name                    = "open-test"
  auto_create_subnetworks = false
  depends_on              = [google_project_service.compute]
}

#subnetwork
resource "google_compute_subnetwork" "tokyo" {
  name          = "tokyo"
  ip_cidr_range = "10.1.0.0/16"
  region        = "asia-northeast1"
  network       = google_compute_network.open-test.id
}
resource "google_compute_subnetwork" "osaka" {
  name          = "osaka"
  ip_cidr_range = "10.2.0.0/16"
  region        = "asia-northeast2"
  network       = google_compute_network.open-test.id
}
resource "google_compute_subnetwork" "oregon" {
  name          = "oregon"
  ip_cidr_range = "192.168.1.0/24"
  region        = "us-west1"
  network       = google_compute_network.open-test.id
}

# firewall
resource "google_compute_firewall" "internal" {
  name    = "internal"
  network = google_compute_network.open-test.id
  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/8", "192.168.0.0/16"]
}

resource "google_compute_firewall" "icmp" {
  name    = "icmp"
  network = google_compute_network.open-test.id
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = google_compute_network.open-test.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "debug" {
  name    = "debug"
  network = google_compute_network.open-test.id
  allow {
    protocol = "tcp"
    ports    = ["34567"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["debug"]
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = <<EOF
      ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGN2d5gioDMwRPTmJl+AWNPT25DkbroduzN3HHQOxI5z6c2zKx+Xfy0yCXLrUH6fZa5d4kvhMcpBMqlAyWSYFAOSKxJddfdbe1p57HDPP1PYDcCDmGHCXNqlmTSj2rfVGoaYuMxqregT4MYTl4qVJ9zD279rdFFWl43ddcY9MDpaWJyiPj+A3cyyLMd/84aKkjjFr7uvozoDbxN/D60G4ejOJQzGfruE0lNAmRmDWuMwYYBU7M3gUaIy7g7T1T3P6h8wZbjfPnArWwEl5Fes4H9II7S/dpjpJdPy9u9fffo+GtIvjzWkW625bVyPHDroMTQtF7vf16mdEfTa005qXbyffM5pTDIiPL+DpZr17HxVATtdH/LFEuV7yP0SmCVc/XF5F1oWlW2tAb5jJI2GeFeyKzL5neAsU96epcPvAm3uVpi8upLXlOzZ4BGaola3kTaZKIU+gqLeLB53YaAQRfIFHMfuDDrYj7eWWaQx8hsWR89VSralTtsMtIcoCX5z0= yukip@MacBookAirM2.local
    EOF
  }
  depends_on = [google_project_service.compute]
}