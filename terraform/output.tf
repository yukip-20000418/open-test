output "service_account" {
  value = google_service_account.osaka.email
}

output "ip_address" {
  value = google_compute_instance.osaka.network_interface[0].access_config[0].nat_ip
}
