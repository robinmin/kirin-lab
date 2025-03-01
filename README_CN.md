# Kirin Lab 🏠🧪

基于Mac mini M4打造的完整家庭服务器实验室，使用Docker容器化技术和自动化配置管理。

## 系统架构

![系统架构](https://via.placeholder.com/800x500)

### 核心组件

- **容器管理**: Portainer + Dockge
- **家庭资源中心**: Nextcloud + iCloud桥接
- **媒体中心**: Jellyfin + Kodi
- **智能家居**: Home Assistant + HomeKit
- **内网穿透**: Tailscale + Cloudflare Tunnel
- **反向代理**: Nginx Proxy Manager
- **家庭管理**: Homechart
- **照片管理**: Immich
- **监控系统**: Prometheus + Grafana
- **备份解决方案**: Duplicati
- **本地DNS**: AdGuard Home
- **安全增强**: Crowdsec + Fail2ban

## 🚀 快速开始

### 前提条件

- Mac mini M4
- macOS Sonoma 15.0+
- 外接存储设备 (SSD + HDD)
- Docker Desktop for Mac 已安装

### 安装步骤

1. **克隆仓库**

```bash
git clone https://github.com/robinmin/kirin-lab.git
cd kirin-lab
```

2. **配置环境变量**

```bash
cp env.example .env
# 编辑 .env 文件设置你的环境变量
```

3. **启动核心服务**

```bash
cd bootstrap
./setup.sh
```

4. **访问管理界面**

初始化完成后，访问以下地址:
- Portainer: http://localhost:9000
- Dockge: http://localhost:5001
- Nginx Proxy Manager: http://localhost:81

## 📁 目录结构说明

```
kirin-lab/           	   # 项目根目录
├── bootstrap/             # 初始化脚本
├── global-env/            # 全局环境变量
├── dockge/                # 容器编排管理
├── core-services/         # 核心服务
├── network/               # 网络服务
├── monitoring/            # 监控服务
├── security/              # 安全服务
├── backup/                # 备份服务
└── iot-devices/           # 智能设备管理
```

## 🛠 配置与定制

### 添加新服务

1. 在相应目录创建新的docker-compose.yml文件
2. 添加到dockge/stacks目录的软链接
3. 从Dockge界面部署新服务

### 更新现有服务

1. 修改相应服务的docker-compose.yml文件
2. 通过Dockge界面重新部署更新

## 📊 资源使用情况

| 服务 | CPU 预估 | 内存预估 | 存储预估 |
|------|---------|---------|---------|
| Nextcloud | 低-中 | 1-2GB | 视内容而定 |
| Jellyfin | 高(转码时) | 2-4GB | 视媒体库大小 |
| Home Assistant | 低 | 1GB | 500MB-1GB |
| Tailscale | 极低 | 100MB | 极少 |
| Nginx Proxy | 低 | 500MB | 100MB |
| Immich | 中-高 | 2GB+ | 视照片库大小 |

## 🔐 安全考虑

- 所有敏感信息通过.env文件管理且被.gitignore忽略
- 反向代理层提供额外安全保障
- 定期自动更新容器以修复安全漏洞
- Fail2ban和Crowdsec提供入侵检测和防护

## 📝 许可证

MIT License

## 🤝 贡献指南

欢迎提交PR和Issues帮助改进此项目！

1. Fork本仓库
2. 创建你的特性分支
3. 提交你的更改
4. 推送到分支
5. 创建新的Pull Request


## 参考
- [Original Prompt on Claude.ai](https://claude.ai/share/146be25e-5574-4a09-82e9-23a75ade1a21)
