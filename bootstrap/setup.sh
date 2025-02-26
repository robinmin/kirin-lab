#!/bin/bash
#
# Mac mini M4 Home Lab 初始化脚本
#

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查是否为root权限
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}此脚本需要管理员权限才能运行${NC}"
   echo -e "${YELLOW}请使用 sudo ./setup.sh 运行${NC}"
   exit 1
fi

# 显示欢迎信息
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}    Mac mini M4 Home Lab 初始化脚本    ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""

# 检查Docker是否已安装
echo -e "${YELLOW}检查Docker安装状态...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}未检测到Docker，请先安装Docker Desktop for Mac${NC}"
    echo -e "${YELLOW}可访问 https://www.docker.com/products/docker-desktop/ 下载${NC}"
    exit 1
fi

echo -e "${GREEN}Docker已安装!✓${NC}"
echo ""

# 检查外部存储设备
echo -e "${YELLOW}检查外部存储设备...${NC}"
# 列出所有卷
diskutil list | grep -E 'external|媒体'
echo ""
echo -e "${YELLOW}请确认以上列出的外部存储设备是否正确挂载${NC}"
read -p "是否继续? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}安装已取消${NC}"
    exit 1
fi

# 创建必要的目录结构
echo -e "${YELLOW}创建目录结构...${NC}"
REPO_DIR=$(dirname $(dirname $(realpath $0)))
cd $REPO_DIR

mkdir -p global-env
mkdir -p bootstrap
mkdir -p dockge/stacks
mkdir -p core-services/{nextcloud,jellyfin,vaultwarden,immich}/{config,data}
mkdir -p core-services/jellyfin/media
mkdir -p core-services/immich/{uploads,postgres}
mkdir -p network/tailscale
mkdir -p network/nginx-proxy-manager/{data,letsencrypt}
mkdir -p iot-devices/{homeassistant,homechart}/{config,data}
mkdir -p iot-devices/stf/devices
mkdir -p monitoring/{grafana,prometheus}/{config,data}
mkdir -p security/{crowdsec,fail2ban}/config
mkdir -p backup/duplicati/config

# 复制环境变量模板文件
echo -e "${YELLOW}设置环境变量...${NC}"
if [ ! -f .env ]; then
    cp bootstrap/env.example .env
    echo -e "${GREEN}已创建.env文件，请编辑设置您的环境变量${NC}"
else
    echo -e "${YELLOW}检测到已存在.env文件，跳过创建${NC}"
fi

# 启动基础服务
echo -e "${YELLOW}启动基础服务...${NC}"
echo -e "${YELLOW}1. 启动Portainer...${NC}"
docker-compose -f bootstrap/portainer-docker-compose.yml up -d

echo -e "${YELLOW}2. 启动Dockge...${NC}"
docker-compose -f dockge/docker-compose.yml up -d

echo -e "${YELLOW}3. 启动Nginx Proxy Manager...${NC}"
docker-compose -f network/nginx-proxy-manager/docker-compose.yml up -d

# 创建软链接
echo -e "${YELLOW}创建服务软链接到Dockge...${NC}"
for service_dir in core-services/*/ network/*/ iot-devices/*/ monitoring/*/ security/*/ backup/*/; do
    if [ -f "${service_dir}docker-compose.yml" ]; then
        service_name=$(basename "$service_dir")
        ln -sf "$(realpath "${service_dir}docker-compose.yml")" "dockge/stacks/${service_name}.yml"
        echo -e "${GREEN}已链接 ${service_name} 到Dockge${NC}"
    fi
done

# 设置权限
echo -e "${YELLOW}设置目录权限...${NC}"
find . -type d -exec chmod 755 {} \;
find . -type f -name "*.sh" -exec chmod +x {} \;

# 显示完成信息
echo ""
echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}    Mac mini M4 Home Lab 初始化完成!    ${NC}"
echo -e "${GREEN}============================================${NC}"
echo ""
echo -e "${YELLOW}管理界面:${NC}"
echo -e "Portainer:   http://localhost:9000"
echo -e "Dockge:      http://localhost:5001"
echo -e "Nginx Proxy: http://localhost:81"
echo ""
echo -e "${YELLOW}后续步骤:${NC}"
echo -e "1. 编辑 .env 文件配置环境变量"
echo -e "2. 使用Dockge部署各服务"
echo -e "3. 配置Nginx Proxy Manager设置反向代理"
echo ""
echo -e "${GREEN}感谢使用本安装脚本!${NC}"
