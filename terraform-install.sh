#!/bin/bash

echo "==========================================="
echo " Installing Latest Terraform Version"
echo "==========================================="

# Install required tools
echo "[+] Installing dependencies (curl, unzip)..."
sudo dnf install -y curl unzip >/dev/null 2>&1

# Fetch latest version dynamically
echo "[+] Fetching latest Terraform version..."
LATEST_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest \
    | grep tag_name | cut -d '"' -f 4 | sed 's/v//')

echo "[+] Latest Terraform version: $LATEST_VERSION"

# Download Terraform
echo "[+] Downloading terraform_${LATEST_VERSION}_linux_amd64.zip..."
curl -s -O https://releases.hashicorp.com/terraform/${LATEST_VERSION}/terraform_${LATEST_VERSION}_linux_amd64.zip

# Extract
echo "[+] Extracting Terraform..."
unzip -o terraform_${LATEST_VERSION}_linux_amd64.zip >/dev/null 2>&1

# Move binary
echo "[+] Moving Terraform to /usr/local/bin..."
sudo mv terraform /usr/local/bin/

# Verify installation
echo "[+] Verifying installation..."
terraform version

# Cleanup
echo "[+] Cleaning up..."
rm terraform_${LATEST_VERSION}_linux_amd64.zip

# Configure autocomplete
echo "[+] Enabling autocomplete..."
terraform -install-autocomplete >/dev/null 2>&1

echo "==========================================="
echo " ✅ Terraform v${LATEST_VERSION} installed successfully!"
echo "==========================================="
