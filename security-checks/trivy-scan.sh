#!/bin/bash

# Trivy container image scanning script
# This script scans container images for vulnerabilities

echo "Running Trivy vulnerability scan on container images..."

# Check if trivy is installed
if ! command -v trivy &> /dev/null; then
    echo "trivy is not installed. Installing..."
    # For macOS
    brew install aquasecurity/trivy/trivy
fi

# Extract image names from deployment manifests
images=$(grep -r "image:" ../manifests/ | awk '{print $2}')

# Scan each image
for image in $images; do
    echo "Scanning image: $image"
    trivy image --severity HIGH,CRITICAL "$image"
    
    # Check exit code - note: we're allowing the pipeline to continue even with vulnerabilities
    # In a real production environment, you might want to fail the pipeline for CRITICAL findings
    if [ $? -ne 0 ]; then
        echo "WARNING: Vulnerabilities found in $image"
    fi
done

echo "Vulnerability scan completed!"
exit 0
