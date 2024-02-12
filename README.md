# Event Streaming using Cloud PubSub and dlt.

## Overview

This is a demo project that provides a template for setting up an event streaming pipeline using Google Cloud Pub/Sub and dlt. It streamlines the process of creating the necessary resources on Google Cloud Platform (GCP) using Terraform and includes a Python script for publishing events to the Pub/Sub topic.

## Prerequisites

Before you can run this pipeline, make sure you have the following prerequisites installed and configured:

- [Terraform](https://www.terraform.io/) - Infrastructure as Code tool.
- [Pub/Sub API](https://pypi.org/project/google-cloud-pubsub/  ) - Google Cloud Pub/Sub API client library.
- Create a project on Google Cloud.
- Create a GCP [service account](https://cloud.google.com/iam/docs/service-accounts-create#iam-service-accounts-create-console) with the following permissions:
  - BigQuery Data Editor
  - BigQuery Job User
  - BigQuery Read Session User
  - Cloud Functions Admin
  - Compute Storage Admin
  - Pub/Sub Admin
  - Service Account User
  - Storage Admin
- Download the service account keys to the local machine.

## Getting Started

Follow these steps to set up and run the event streaming pipeline:
- Pass the credentials as environment variables.
```
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/keyfile.json"
```
- Pass the credentidial path in `terraform/main.tf`.
```
provider "google" {
  credentials = file("./../credentials.json")
  project = var.project_id
  region  = var.region
}
```
- Add the variables from service account key in `terraform/variables.tf`.
```
variable "project_id" {
  type = string
  default = "Add Project ID"
}

variable "region" {
  type = string
  default = "Add Region"
}

variable "service_account_email" {
  type = string
  default = "Add Service Account Email"
  
}
```
- Navigate to the terraform directory and execute the commands below to procure resources.
```
terraform init
terraform plan
terraform apply
```
- Add the below info to the `publisher.py`
```
# TODO(developer)
project_id = "Add GCP Project ID"
topic_id = "Add Topic ID"
```
- Run the publisher to test the pipeline.
```
python publisher.py
```