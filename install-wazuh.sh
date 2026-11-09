#!/bin/bash
set -e

echo "=== Starting Wazuh (light, single-node) Installation ==="
BASE_DIR="$(pwd)"

# 1. Kernel setting needed by the indexer
echo "vm.max_map_count=262144" | sudo tee /etc/sysctl.d/99-wazuh.conf
sudo sysctl --system

# 2. Install Docker and Compose if missing
if ! command -v docker &> /dev/null || ! docker compose version &> /dev/null; then
    echo "-> Installing Docker Engine and Docker Compose..."
    sudo apt update
    sudo apt install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    sudo tee /etc/apt/sources.list.d/docker.sources <<DEEOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
DEEOF

    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
fi

# 3. Git and docker group
sudo apt install -y git
sudo usermod -aG docker $USER || true

# 4. Get the official Wazuh Docker files (v4.9.0)
if [ ! -d wazuh-docker ]; then
    echo "-> Cloning official wazuh-docker v4.9.0..."
    git clone https://github.com/wazuh/wazuh-docker.git -b v4.9.0
fi
cd wazuh-docker/single-node

# 5. Generate certificates (first time only)
if [ ! -d config/wazuh_indexer_ssl_certs ]; then
    echo "-> Generating certificates..."
    sudo docker compose -f generate-indexer-certs.yml run --rm generator
fi

# 6. Start Wazuh: official file + your light docker-compose.yml on top
echo "-> Pulling images and starting Wazuh..."
sudo docker compose -f docker-compose.yml -f "$BASE_DIR/docker-compose.yml" up -d

echo "=== Done! Wait 3-5 minutes, then open https://$(hostname -I | awk '{print $1}') ==="
