variable "project_id" {
  type = string
  default = "dlthub-analytics"
}

variable "region" {
  type = string
  default = "europe-west1"
}

variable "service_account_email" {
  type = string
  default = "pubsub-demo@dlthub-analytics.iam.gserviceaccount.com"
  
}