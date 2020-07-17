terraform {
  backend "gcs" {
    credentials = "./service_account.json"
    bucket  = "terraform-workshop-states"
    prefix  = "terraform/state"
  }
}

provider "google" {
  credentials = file("./service_account.json")
  project     = "terraform-workshop-283612"
  region      = "europe-west2"
}

resource "google_storage_bucket" "bucket_gustavo" {
  name          = "my-test-bucket-for-gustavo"
  location      = "EU"
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  bucket_policy_only = true
}