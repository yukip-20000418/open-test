# set project
gcloud config set project dev-chottodake-open-test

# api & service

# BigQuery Storage API
gcloud services disable bigquerystorage.googleapis.com --force
# BigQuery API
gcloud services disable bigquery.googleapis.com --force
# BigQuery Migration API
gcloud services disable bigquerymigration.googleapis.com --force


# Google Cloud APIs
gcloud services disable cloudapis.googleapis.com

# Cloud Debugger API
gcloud services disable clouddebugger.googleapis.com --force

# Cloud Trace API
gcloud services disable cloudtrace.googleapis.com --force

# Cloud Datastore API
gcloud services disable datastore.googleapis.com --force

# Cloud Firestore API
gcloud services disable firestore.googleapis.com
# Firebase Rules API
gcloud services disable firebaserules.googleapis.com


# IAM Service Account Credentials API
gcloud services disable iamcredentials.googleapis.com

# Cloud Logging API
gcloud services disable logging.googleapis.com --force

# Cloud Monitoring API
gcloud services disable monitoring.googleapis.com --force

# Cloud OS Login API
gcloud services disable oslogin.googleapis.com

# Service Management API
gcloud services disable servicemanagement.googleapis.com --force

# Service Usage API
#gcloud services disable serviceusage.googleapis.com

# Cloud SQL
gcloud services disable sql-component.googleapis.com

# Google Cloud Storage JSON API
gcloud services disable storage-api.googleapis.com

# Cloud Storage
gcloud services disable storage-component.googleapis.com --force

# Cloud Storage API
gcloud services disable storage.googleapis.com


# service account
# gcloud iam service-accounts create terraform \
#     --description="terraform" \
#     --display-name="terraform"

# gcloud projects add-iam-policy-binding dev-chottodake-open-test \
#     --member="serviceAccount:terraform@dev-chottodake-open-test.iam.gserviceaccount.com" \
#     --role="roles/editor"

# create buckets for tfstate
# gcloud services enable storage.googleapis.com

gcloud storage buckets create gs://test.open.chottodake.dev \
  --default-storage-class=STANDARD \
  --location=ASIA-NORTHEAST2 \
  --uniform-bucket-level-access
