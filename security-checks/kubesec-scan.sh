#!/bin/bash

# KubeSec security scanning script
# This script scans Kubernetes manifests for security issues

echo "Running KubeSec security scan on Kubernetes manifests..."

# Check if kubesec is installed
if ! command -v kubesec &> /dev/null; then
    echo "kubesec is not installed. Installing..."
    # For macOS
    brew install kubesec/tap/kubesec
fi

# Scan all yaml files in the manifests directory
for file in ../manifests/*.yaml; do
    echo "Scanning $file..."
    kubesec scan "$file"
    
    # Check exit code
    if [ $? -ne 0 ]; then
        echo "Security issues found in $file"
        exit 1
    fi
done

echo "Security scan completed successfully!"
exit 0
