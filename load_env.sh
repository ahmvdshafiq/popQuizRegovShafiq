#!/bin/bash

# Load variables from .env file
export $(grep -v '^#' .env | xargs)

# Run Terraform commands
terraform "$@"
