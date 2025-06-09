#!/bin/bash

# Configuration
REPO_URL="https://raw.githubusercontent.com/souravjoy7/vps-benchmark/main"
SCRIPT_NAME="vps-benchmark.sh"
INSTALL_PATH="/usr/local/bin/vps-benchmark"

# Download and install
echo "Installing VPS Benchmark..."
sudo curl -s "${REPO_URL}/${SCRIPT_NAME}" -o "${INSTALL_PATH}" || {
    echo "Error: Download failed!" >&2
    exit 1
}
sudo chmod +x "${INSTALL_PATH}"
echo "Success! Run with: sudo vps-benchmark"
