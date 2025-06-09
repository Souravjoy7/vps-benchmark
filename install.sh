#!/bin/bash

# Config
REPO_URL="https://raw.githubusercontent.com/souravjoy7/vps-benchmark/main"
SCRIPT_NAME="vps-benchmark.sh"
INSTALL_PATH="/usr/local/bin/vps-benchmark"

# Install function
install() {
    echo "Installing VPS Benchmark..."
    sudo curl -s "${REPO_URL}/${SCRIPT_NAME}" -o "${INSTALL_PATH}" || {
        echo "Error: Download failed!" >&2
        exit 1
    }
    sudo chmod +x "${INSTALL_PATH}"
    echo "✅ Installed! Run with: sudo vps-benchmark"
}

# Uninstall function
uninstall() {
    echo "Removing VPS Benchmark..."
    sudo rm -f "${INSTALL_PATH}" && \
    echo "✅ Uninstalled. Script removed." || \
    echo "⚠️  Error: Could not remove script (may not exist)."
}

# Parse arguments
case "$1" in
    --uninstall)
        uninstall
        ;;
    *)
        install
        ;;
esac
