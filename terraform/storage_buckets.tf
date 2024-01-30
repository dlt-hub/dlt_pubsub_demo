# Bucket for Subscription to Push to Cloud Storage
resource "google_storage_bucket" "tel_bucket_storage" {
  name          = "tel_storage"
  location      = var.region
  force_destroy = true // Allows the bucket to be deleted even if it contains objects
  uniform_bucket_level_access = true
  public_access_prevention = "enforced"
}

# resource "google_storage_bucket" "tel_bucket_pull" {
#   name          = "tel_pull"
#   location      = "EU"
#   force_destroy = true
#   uniform_bucket_level_access = true
#   public_access_prevention= "enforced"
# }

# Bucket to Store the Cloud Function Code
resource "google_storage_bucket" "cf_pubsub_storage" {
  name          = "pubsub_cfunctions"
  location      = var.region  # Change to your desired region
  force_destroy = true  # Remove this line if you don't want to allow bucket deletion
  uniform_bucket_level_access = true
  public_access_prevention= "enforced"
}