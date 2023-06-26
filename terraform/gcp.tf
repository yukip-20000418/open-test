# provider "google-beta" {
provider "google" {
  project = "dev-chottodake-open-test"
  region  = "asia-northeast1"
#   zone    = "asia-northeast1-a"
#   credentials = data.google_secret_manager_secret_version.key_json.secret_data
}

# data "google_secret_manager_secret_version" "key_json" {
#   project   = "dev-chottodake-open-test"
#   secret = "terraform-key-json"
# }
