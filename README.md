# Event Streaming using Cloud PubSub and dlt.

## Overview

This is a demo project that provides a template for setting up an event streaming pipeline using Google Cloud Pub/Sub and dlt. It streamlines the process of creating the necessary resources on Google Cloud Platform (GCP) ussing Terraform and includes a Python script for publishing events to the Pub/Sub topic.

## Prerequisites

Before you can run this pipeline, make sure you have the following prerequisites installed and configured:

- [Terraform](https://www.terraform.io/) - Infrastructure as Code tool
- [Google Cloud SDK](https://cloud.google.com/sdk) - Command-line tools for Google Cloud Platform
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
