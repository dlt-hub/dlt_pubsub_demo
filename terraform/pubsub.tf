# PubSub Topic
resource "google_pubsub_topic" "tera_tel_data" {  
  name = "telemetry_data_tera"
}

# PubSub Subscription writes to cloud storage
resource "google_pubsub_subscription" "tel_sub" {
  name  = "push_sub_storage"
  topic = google_pubsub_topic.tera_tel_data.id

  cloud_storage_config {
    bucket = google_storage_bucket.tel_bucket_storage.name

    filename_prefix = "telemetry-"

    max_duration = "300s"
    max_bytes = 10000

  }
  depends_on = [ 
    google_storage_bucket.tel_bucket_storage,
    google_storage_bucket_iam_member.admin,
  ]
}

data "google_project" "project" {
    # project_id = var.project_id
}

resource "google_storage_bucket_iam_member" "admin" {
  bucket = google_storage_bucket.tel_bucket_storage.name
  role   = "roles/storage.admin"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
}