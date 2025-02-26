# Mac mini M4 Home Lab 🏠🧪

A complete home server lab based on Mac mini M4, using Docker containerization and automated configuration management.

## System Architecture

![System Architecture](https://via.placeholder.com/800x500)

### Core Components

- **Container Management**: Portainer + Dockge
- **Home Resource Center**: Nextcloud + iCloud Bridge
- **Media Center**: Jellyfin + Kodi
- **Smart Home**: Home Assistant + HomeKit
- **Remote Access**: Tailscale + Cloudflare Tunnel
- **Reverse Proxy**: Nginx Proxy Manager
- **Home Management**: Homechart
- **Photo Management**: Immich
- **Monitoring System**: Prometheus + Grafana
- **Backup Solution**: Duplicati
- **Local DNS**: AdGuard Home
- **Security Enhancement**: Crowdsec + Fail2ban

## 🚀 Quick Start

### Prerequisites

- Mac mini M4
- macOS Sonoma 15.0+
- External storage devices (SSD + HDD)
- Docker Desktop for Mac installed

### Installation Steps

1. **Clone Repository**

```bash
git clone https://github.com/robinmin/kirin-lab.git
cd kirin-lab
```

2. **Configure Environment Variables**

```bash
cp env.example .env
# Edit .env file to set your environment variables
```

3. **Start Core Services**

```bash
cd bootstrap
./setup.sh
```

4. **Access Management Interfaces**

After initialization, access the following addresses:
- Portainer: http://localhost:9000
- Dockge: http://localhost:5001
- Nginx Proxy Manager: http://localhost:81

## 📁 Directory Structure

```
kirin-lab/                 # Project root
├── bootstrap/             # Initialization scripts
├── global-env/            # Global environment variables
├── dockge/                # Container orchestration management
├── core-services/         # Core services
├── network/               # Network services
├── monitoring/            # Monitoring services
├── security/              # Security services
├── backup/                # Backup services
└── iot-devices/           # Smart device management
```

## 🛠 Configuration & Customization

### Adding New Services

1. Create a new docker-compose.yml file in the appropriate directory
2. Add a symbolic link to the dockge/stacks directory
3. Deploy the new service from the Dockge interface

### Updating Existing Services

1. Modify the docker-compose.yml file of the corresponding service
2. Redeploy via the Dockge interface to update

## 📊 Resource Usage

| Service | CPU Estimate | Memory Estimate | Storage Estimate |
|---------|--------------|----------------|------------------|
| Nextcloud | Low-Medium | 1-2GB | Depends on content |
| Jellyfin | High (when transcoding) | 2-4GB | Depends on media library |
| Home Assistant | Low | 1GB | 500MB-1GB |
| Tailscale | Very Low | 100MB | Minimal |
| Nginx Proxy | Low | 500MB | 100MB |
| Immich | Medium-High | 2GB+ | Depends on photo library |

## 🔐 Security Considerations

- All sensitive information is managed through .env files and ignored by git
- Reverse proxy layer provides additional security
- Automatic container updates to fix security vulnerabilities
- Fail2ban and Crowdsec provide intrusion detection and prevention

## 📝 License

MIT License

## 🤝 Contribution Guidelines

Contributions via PRs and Issues are welcome to help improve this project!

1. Fork this repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
