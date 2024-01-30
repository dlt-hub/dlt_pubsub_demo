# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "./../cloud_functions_src"
  output_path = "./../tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.cf_pubsub_storage.name
  depends_on = [
    google_storage_bucket.cf_pubsub_storage,
    data.archive_file.source
  ]
}

# Cloud Function that writes to BigQuery
resource "google_cloudfunctions2_function" "pubsub_function1" {
  name = "storage_bigquery"
  description = "a new function"
  location = var.region

  build_config {
    runtime = "python311"
    entry_point = "storage_bigquery"  # Set the entry point 
    source {
      storage_source {
        bucket = google_storage_bucket.cf_pubsub_storage.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count  = 3
    min_instance_count = 1
    available_memory    = "1G"
    timeout_seconds     = 60
    service_account_email = var.service_account_email
  }

  event_trigger {
    trigger_region = var.region
    event_type = "google.cloud.storage.object.v1.finalized"
    service_account_email = var.service_account_email
    event_filters {
      attribute = "bucket"
      value     = google_storage_bucket.tel_bucket_storage.name
    }
  }

  depends_on = [
    google_storage_bucket.cf_pubsub_storage,
    google_storage_bucket_object.zip
  ]

}
