provider "google" {
  credentials = file("./service_account.json")
  project     = "terraform-workshop-283612"
  region      = "europe-west2"
}
