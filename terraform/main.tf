

provider "google" {
  credentials = file("./../credentials.json")
  project = var.project_id
  region  = var.region
}

# resource "google_service_account" "account" {
#   account_id = var.project_id
#   display_name = "Test Service Account"
# }

# # Bucket for Subscription to Push to Cloud Storage
# resource "google_storage_bucket" "tel_bucket_storage" {
#   name          = "tel_storage"
#   location      = "EU"
#   force_destroy = true // Allows the bucket to be deleted even if it contains objects
#   uniform_bucket_level_access = true
#   public_access_prevention = "enforced"
# }

# # resource "google_storage_bucket" "tel_bucket_pull" {
# #   name          = "tel_pull"
# #   location      = "EU"
# #   force_destroy = true
# #   uniform_bucket_level_access = true
# #   public_access_prevention= "enforced"
# # }

# # Bucket to Store the Cloud Function Code
# resource "google_storage_bucket" "cf_pubsub_storage" {
#   name          = "pubsub_cfunctions"
#   location      = "EU"  # Change to your desired region
#   force_destroy = true  # Remove this line if you don't want to allow bucket deletion
#   uniform_bucket_level_access = true
#   public_access_prevention= "enforced"
# }

# # Name of object containg Cloud Function code
# resource "google_storage_bucket_object" "cf_object1" {
#   name   = "pubsub_function1.zip"
#   bucket = google_storage_bucket.cf_pubsub_storage.name
#   source = "./../pubsub_function1.zip" 
# }

# # Cloud Function that writes to BigQuery
# resource "google_cloudfunctions2_function" "pubsub_function1" {
#   name = "storage_bigquery"
#   description = "a new function"
#   location = "eu-west1"

#   build_config {
#     runtime = "python311"
#     entry_point = "storage_bigquery"  # Set the entry point 
#     source {
#       storage_source {
#         bucket = google_storage_bucket.cf_pubsub_storage.name
#         object = google_storage_bucket_object.cf_object1.name
#       }
#     }
#   }

#   service_config {
#     max_instance_count  = 1
#     available_memory    = "1G"
#     timeout_seconds     = 60
#     service_account_email = google_service_account.account.email
#   }

#   event_trigger {
#     event_type = "google.storage.object.v1.finalized"
#     event_filters {
#       attribute = "bucket"
#       value     = google_storage_bucket.tel_bucket_storage.name
#     }
#   }

# }

# # resource "google_cloudfunctions_function" "pubsub_function1" {
# #   name             = "storage_bigquery"
# #   description      = "Function triggered when an object is created in the bucket"
# #   runtime          = "python311"
  

# #   available_memory_mb = 1024
# #   timeout            = 60

# #   source_archive_bucket = google_storage_bucket.cf_pubsub_storage.name
# #   source_archive_object = google_storage_bucket_object.cf_object1.name  # Update with your function code

# #   entry_point = "storage_bigquery"  # Update with the name of your function

# #   event_trigger {
# #     event_type = "google.storage.object.finalize"
# #     resource   = google_storage_bucket.tel_bucket_storage.name
# #   }

# #   environment_variables = {
# #     BUCKET_NAME = google_storage_bucket.tel_bucket_storage.name
# #   }

# # }

# # PubSub Topic
# resource "google_pubsub_topic" "tera_tel_data" {
#   name = "tellemetry_data_tera"
# }

# # PubSub Subscription writes to cloud storage
# resource "google_pubsub_subscription" "tel_sub" {
#   name  = "push_sub_storage"
#   topic = google_pubsub_topic.tera_tel_data.id

#   cloud_storage_config {
#     bucket = google_storage_bucket.tel_bucket_storage.name

#     filename_prefix = "telemetry-"

#     max_bytes = 1000
#     max_duration = "300s"

#   }
#   depends_on = [ 
#     google_storage_bucket.tel_bucket_storage,
#     google_storage_bucket_iam_member.admin,
#   ]
# }

# resource "google_storage_bucket_iam_member" "iam_cloud_function1" {
#   bucket = google_storage_bucket.tel_bucket_storage.name
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:${google_cloudfunctions2_function.pubsub_function1.service_account_email}"
# }

# resource "google_storage_bucket_iam_member" "admin" {
#   bucket = google_storage_bucket.tel_bucket_storage.name
#   role   = "roles/storage.admin"
#   #member = "serviceAccount:${google_service_account.account.account_id}@gcp-sa-pubsub.iam.gserviceaccount.com"
# }   

