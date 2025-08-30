#!/usr/bin/env bash

set -euo pipefail

# Initialize Terraform
terraform init

# Validate Terraform configuration
terraform validate

# Show Terraform plan and save it to a file
terraform plan -out=tfplan

# Apply the Terraform plan
terraform apply -auto-approve tfplan

# Clean up the plan file
rm -f tfplan