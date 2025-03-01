# Kirin Lab 安装指南

本指南将帮助你在Mac mini M4上安装和配置完整的Home Lab环境。

## 系统要求

- Mac mini M4 (任何配置均可)
- macOS Sonoma 15.0+
- 至少一个外接存储设备（推荐SSD + HDD配置）
- Docker Desktop for Mac

## 安装步骤

### 1. 安装Docker Desktop for Mac

首先，你需要安装Docker Desktop for Mac：

1. 访问 [Docker官网](https://www.docker.com/products/docker-desktop/)
2. 下载并安装Docker Desktop（Apple Silicon版本）
3. 启动Docker Desktop并等待初始化完成

### 2. 克隆仓库

```bash
git clone https://github.com/robinmin/kirin-lab.git
cd kirin-lab
```

### 3. 配置外部存储设备

1. 将外部SSD和HDD连接到Mac mini
2. 确保它们已正确格式化（建议APFS格式）
3. 在Finder中确认它们已挂载

### 4. 配置环境变量

```bash
cp bootstrap/env.example .env
```

编辑.env文件，设置以下关键配置：

- 修改`DATA_PATH`指向你的SSD挂载点
- 修改`MEDIA_PATH`指向你的HDD媒体目录
- 修改`BACKUP_PATH`指向你的备份目录
- 设置强密码替换所有的`change_me_now`值
- 配置Tailscale认证密钥（如果使用）
- 配置Cloudflare相关信息（如果使用）

### 5. 运行安装脚本

```bash
sudo ./bootstrap/setup.sh
```

安装脚本将创建必要的目录结构并启动核心服务。

### 6. 访问管理界面

初始化完成后，访问以下地址:

- Portainer: [http://localhost:9000](http://localhost:9000)
- Dockge: [http://localhost:5001](http://localhost:5001)
- Nginx Proxy Manager: [http://localhost:81](http://localhost:81)

### 7. 启动服务

1. 登录Dockge管理界面
2. 逐个部署以下服务组：
   - 基础服务（Portainer, Dockge, Nginx Proxy Manager）
   - 网络服务（Traefik, Tailscale, Cloudflared）
   - 核心服务（Nextcloud, Jellyfin, Vaultwarden, Immich）
   - 安全服务（Crowdsec, Fail2ban, AdGuard Home）
   - 监控服务（Prometheus, Grafana, Uptime Kuma）
   - 备份服务（Duplicati）
   - 智能家居服务（Home Assistant, Homebridge, Homechart）

### 8. 配置Nginx Proxy Manager

1. 访问 [http://localhost:81](http://localhost:81)
2. 使用默认凭据登录（admin@example.com / changeme）
3. 添加反向代理，指向各个服务
4. 为本地域名添加SSL证书

### 9. 配置Tailscale访问

1. 登录Tailscale管理界面获取API密钥
2. 将API密钥添加到`.env`文件的`TAILSCALE_AUTHKEY`变量
3. 重启Tailscale容器

### 10. 配置备份

1. 登录Duplicati [http://localhost:8200](http://localhost:8200)
2. 创建新的备份任务，选择要备份的数据
3. 设置备份计划（推荐每日备份）

## 高级配置

### Cloudflare Tunnel设置

如需使用Cloudflare Tunnel进行外部访问：

1. 创建Cloudflare账户并添加你的域名
2. 在Cloudflare Zero Trust中创建新的Tunnel
3. 获取Tunnel Token并配置到cloudflared容器中

### Home Assistant集成

Home Assistant配置目录位于：

```
${DATA_PATH}/homeassistant/config
```

1. 编辑`configuration.yaml`添加所需集成
2. 将智能设备连接到相同网络
3. 添加HomeKit桥接配置

### 添加自定义服务

如需添加新服务：

1. 在相应目录创建新的docker-compose.yml文件
2. 添加到dockge/stacks目录的软链接
3. 从Dockge界面部署新服务

## 故障排除

### 服务无法启动

检查日志：

```bash
docker logs [容器名]
```

### 网络连接问题

检查Docker网络配置：

```bash
docker network inspect homelab_network
```

### 存储空间问题

检查磁盘使用情况：

```bash
df -h
```

## 维护计划

- **每日**：检查自动备份状态
- **每周**：查看监控数据，确保所有服务正常运行
- **每月**：执行系统更新，检查安全日志

## 联系与支持

如有问题，请提交GitHub Issue或发送邮件至：your.email@example.com
