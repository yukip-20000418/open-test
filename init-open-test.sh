#!/bin/bash
set -v

# set project
gcloud config set project dev-chottodake-open-test


# api & service list
gcloud services list --format='csv(TITLE,NAME)' \
| awk 'NR>=2 {print}' \
| sort \
| awk -F, '{printf("# %s\n%s %s %s\n",$1,"gcloud services disable",$2,"--force")}' \
> /tmp/disable-services.sh


# api & service disable
bash -v /tmp/disable-services.sh


# api & service enable
gcloud services enable serviceusage.googleapis.com


# service account
gcloud iam service-accounts delete terraform@dev-chottodake-open-test.iam.gserviceaccount.com --quiet

gcloud iam service-accounts create terraform

gcloud projects add-iam-policy-binding dev-chottodake-open-test \
--member="serviceAccount:terraform@dev-chottodake-open-test.iam.gserviceaccount.com" \
--role="roles/owner"

gcloud iam service-accounts keys create /tmp/terraform-key.json \
--iam-account="terraform@dev-chottodake-open-test.iam.gserviceaccount.com"


# secret manager
gcloud services enable secretmanager.googleapis.com

sleep 5

gcloud secrets delete terraform-key-json --quiet

gcloud secrets create terraform-key-json --quiet \
--replication-policy="automatic" \
--data-file="/tmp/terraform-key.json"


# create buckets for tfstate
gcloud storage buckets create gs://test.open.chottodake.dev \
--default-storage-class="STANDARD" \
--location="ASIA-NORTHEAST2" \
--uniform-bucket-level-access
