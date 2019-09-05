#!/bin/bash

set -euo pipefail

tfstate_file=terraform/terraform.tfstate
sa_resource_name=service_account_key
sa_key_file=__sa-key.json

jq -r ".resources[] | select(.type == \"google_service_account_key\" and .name == \"$sa_resource_name\").instances[0].attributes.private_key | @base64d" \
    $tfstate_file > $sa_key_file
