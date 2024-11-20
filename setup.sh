#!/bin/bash
# Ensure required variables are set in .env
source .env 2>/dev/null || {
  echo "Error: CLOUD_USER and CLOUD_PASSWORD must be set in .env."
  exit 1
}

[ -z "$CLOUD_USER" ] && echo "Error: CLOUD_USER is not set in .env." && exit 1
[ -z "$CLOUD_PASSWORD" ] && echo "Error: CLOUD_PASSWORD is not set in .env." && exit 1

# Replace placeholders in template files
sed -i "s|{{CLOUD_USER}}|$CLOUD_USER|g" t-ubu.template.sh cp-ubu.template.sh
sed -i "s|{{CLOUD_PASSWORD}}|$CLOUD_PASSWORD|g" t-ubu.template.sh cp-ubu.template.sh

echo "Setup complete. Files have been updated with your credentials."
