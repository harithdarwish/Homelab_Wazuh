# Homelab Wazuh

An automated deployment setup for self-hosting a lightweight **Wazuh** (Single-Node) SIEM stack via Docker Compose inside a Linux environment.

Prerequisites:
- A fresh Linux environment (Debian 12 / Ubuntu recommended) with at least 45GB root volume space.
- Root or sudo privileges to configure kernel parameters, install system packages, and run Docker.

---

## Steps

1. Clone the Repository
Download the project repository and setup files from GitHub:
```bash
git clone https://github.com/harithdarwish/Homelab_Wazuh.git
```

   2) Create your custom .env file for secrets and configuration.
```bash
cd ~/Homelab_Vault
```

4) Make the script executable. Install Docker & Docker Compose.
 ```bash
 chmod +x install-wazuh.sh && sudo ./install-wazuh.sh
```

6) Run without sudo
 ```bash
 newgrp docker
```

7) Pull the required container images and start the NPM stack in the background.
```bash
docker compose up -d
```

8) Verify that all service containers
```bash
docker compose ps
```

9) Access the web.
      hostname -I
      http://<HOST_IP>:443
