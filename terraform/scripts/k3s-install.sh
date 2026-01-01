#!/bin/bash
set -e

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install K3s
curl -sfL https://get.k3s.io | sh -s - \
  --write-kubeconfig-mode 644 \
  --disable traefik \
  --disable servicelb

# Wait for K3s to be ready
echo "Waiting for K3s to be ready..."
until k3s kubectl get nodes | grep -q Ready; do
  echo "Still waiting..."
  sleep 5
done

echo "K3s installation complete!"
