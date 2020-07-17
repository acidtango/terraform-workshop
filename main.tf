terraform {
  backend "gcs" {
    credentials = "./service_account.json"
    bucket      = "terraform-workshop-states"
    prefix      = "terraform/state"
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

resource "google_storage_notification" "notification" {
  bucket         = google_storage_bucket.bucket_gustavo.name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic.id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

resource "google_pubsub_topic_iam_binding" "binding" {
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account.email_address}"]
}

data "google_storage_project_service_account" "gcs_account" {
}

resource "google_pubsub_topic" "topic" {
  name = "default_topic"
}
