
# Sandbox GCP

## Prerequisites

* Docker
* [Terraform](https://www.terraform.io)
* Environment variable `GCP_BILLING_ACCOUNT_ID` is set
* Authenticated to GCP with `gcloud auth login`

## Usage

1. Create a project on GCP if you want to deploy to a new one.
1. Go `terraform` directory.
1. [`config.auto.tfvars`](./config.auto.tfvars) as you like.
1. Set following environment variables:

    ```sh
    export TF_VAR_access_token="$(gcloud auth print-access-token)"
    ```

1. Run `terraform init`
1. Run `terraform apply`
