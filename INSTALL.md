# Mac mini M4 Home Lab Installation Guide

This guide will help you install and configure a complete Home Lab environment on your Mac mini M4.

## System Requirements

- Mac mini M4 (any configuration)
- macOS Sonoma 15.0+
- At least one external storage device (SSD + HDD configuration recommended)
- Docker Desktop for Mac

## Installation Steps

### 1. Install Docker Desktop for Mac

First, you need to install Docker Desktop for Mac:

1. Visit [Docker's official website](https://www.docker.com/products/docker-desktop/)
2. Download and install Docker Desktop (Apple Silicon version)
3. Launch Docker Desktop and wait for initialization to complete

### 2. Clone the Repository

```bash
git clone https://github.com/robinmin/kirin-lab.git
cd kirin-lab
```

### 3. Configure External Storage Devices

1. Connect your external SSD and HDD to the Mac mini
2. Ensure they are properly formatted (APFS format recommended)
3. Confirm they are mounted in Finder

### 4. Configure Environment Variables

```bash
cp bootstrap/env.example .env
```

Edit the .env file to set the following key configurations:

- Modify `DATA_PATH` to point to your SSD mount point
- Modify `MEDIA_PATH` to point to your HDD media directory
- Modify `BACKUP_PATH` to point to your backup directory
- Set strong passwords to replace all `change_me_now` values
- Configure Tailscale authentication key (if using)
- Configure Cloudflare-related information (if using)

### 5. Run the Installation Script

```bash
cd bootstrap
sudo ./setup.sh
```

The installation script will create the necessary directory structure and start core services.

### 6. Access Management Interfaces

After initialization, access the following addresses:

- Portainer: [http://localhost:9000](http://localhost:9000)
- Dockge: [http://localhost:5001](http://localhost:5001)
- Nginx Proxy Manager: [http://localhost:81](http://localhost:81)

### 7. Launch Services

1. Log in to the Dockge management interface
2. Deploy each service group one by one:
   - Basic services (Portainer, Dockge, Nginx Proxy Manager)
   - Network services (Traefik, Tailscale, Cloudflared)
   - Core services (Nextcloud, Jellyfin, Vaultwarden, Immich)
   - Security services (Crowdsec, Fail2ban, AdGuard Home)
   - Monitoring services (Prometheus, Grafana, Uptime Kuma)
   - Backup services (Duplicati)
   - Smart home services (Home Assistant, Homebridge, Homechart)

### 8. Configure Nginx Proxy Manager

1. Visit [http://localhost:81](http://localhost:81)
2. Log in with default credentials (admin@example.com / changeme)
3. Add reverse proxies pointing to various services
4. Add SSL certificates for local domain names

### 9. Configure Tailscale Access

1. Log in to the Tailscale management interface to get an API key
2. Add the API key to the `TAILSCALE_AUTHKEY` variable in the `.env` file
3. Restart the Tailscale container

### 10. Configure Backups

1. Log in to Duplicati [http://localhost:8200](http://localhost:8200)
2. Create a new backup job, selecting the data you want to back up
3. Set up a backup schedule (daily backups recommended)

## Advanced Configuration

### Cloudflare Tunnel Setup

To use Cloudflare Tunnel for external access:

1. Create a Cloudflare account and add your domain
2. Create a new Tunnel in Cloudflare Zero Trust
3. Get the Tunnel Token and configure it in the cloudflared container

### Home Assistant Integration

The Home Assistant configuration directory is located at:

```
${DATA_PATH}/homeassistant/config
```

1. Edit `configuration.yaml` to add required integrations
2. Connect smart devices to the same network
3. Add HomeKit bridge configuration

### Adding Custom Services

To add new services:

1. Create a new docker-compose.yml file in the appropriate directory
2. Add a symbolic link to the dockge/stacks directory
3. Deploy the new service from the Dockge interface

## Troubleshooting

### Services Not Starting

Check logs:

```bash
docker logs [container-name]
```

### Network Connection Issues

Check Docker network configuration:

```bash
docker network inspect homelab_network
```

### Storage Space Issues

Check disk usage:

```bash
df -h
```

## Maintenance Plan

- **Daily**: Check automatic backup status
- **Weekly**: Review monitoring data, ensure all services are running properly
- **Monthly**: Perform system updates, check security logs

## Contact & Support

If you have any questions, please submit a GitHub Issue or send an email to: your.email@example.com
