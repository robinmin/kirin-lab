#!/bin/bash
#
# KirinLab - Mac mini M4 Home Lab Management Script
#

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 定义服务的docker-compose文件路径
PORTAINER_COMPOSE="$(dirname ${SCRIPT_DIR})/bootstrap/portainer-docker-compose.yml"
DOCKGE_COMPOSE="$(dirname ${SCRIPT_DIR})/dockge/docker-compose.yml"
TRAEFIK_COMPOSE="$(dirname ${SCRIPT_DIR})/network/traefik/docker-compose.yml"

# 检查.env文件是否存在
ENV_FILE="$(dirname ${SCRIPT_DIR})/.env"
if [ ! -f "${ENV_FILE}" ]; then
    echo -e "${RED}.env文件不存在。请先创建.env文件。${NC}"
    if [ -f "${SCRIPT_DIR}/env.example" ]; then
        echo -e "${YELLOW}可以复制env.example作为起点:${NC}"
        echo -e "${BLUE}cp ${SCRIPT_DIR}/env.example ${ENV_FILE}${NC}"
    fi
    exit 1
fi

# 检查docker是否运行
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        echo -e "${RED}无法连接到Docker。请确保Docker已启动。${NC}"
        exit 1
    fi
}

# 显示帮助信息
show_help() {
    echo -e "${GREEN}KirinLab - Kirin Lab管理脚本${NC}\n"
    echo -e "用法: $0 [命令] [服务]"
    echo -e ""
    echo -e "命令:"
    echo -e "  ${YELLOW}start${NC}     启动指定服务或全部服务"
    echo -e "  ${YELLOW}stop${NC}      停止指定服务或全部服务"
    echo -e "  ${YELLOW}restart${NC}   重启指定服务或全部服务"
    echo -e "  ${YELLOW}status${NC}    查看服务状态"
    echo -e "  ${YELLOW}logs${NC}      查看服务日志"
    echo -e "  ${YELLOW}help${NC}      显示帮助信息"
    echo -e ""
    echo -e "服务:"
    echo -e "  ${BLUE}portainer${NC}   Portainer容器管理界面"
    echo -e "  ${BLUE}dockge${NC}      Dockge Docker Compose管理"
    echo -e "  ${BLUE}traefik${NC}     Traefik"
    echo -e "  ${BLUE}all${NC}         所有核心服务 (默认)"
    echo -e ""
    echo -e "示例:"
    echo -e "  $0 start            # 启动所有服务"
    echo -e "  $0 stop portainer   # 仅停止Portainer"
    echo -e "  $0 restart traefik  # 重启Traefik"
    echo -e "  $0 status           # 查看所有服务状态"
    echo -e "  $0 logs dockge      # 查看Dockge日志"
}

# 处理单个服务命令
handle_service() {
    local command=$1
    local service=$2
    local compose_file=""
    local service_name=""

    case $service in
        "portainer")
            compose_file=$PORTAINER_COMPOSE
            service_name="Portainer"
            ;;
        "dockge")
            compose_file=$DOCKGE_COMPOSE
            service_name="Dockge"
            ;;
        "traefik")
            compose_file=$TRAEFIK_COMPOSE
            service_name="Traefik"
            ;;
        *)
            echo -e "${RED}未知服务: $service${NC}"
            show_help
            exit 1
            ;;
    esac

    case $command in
        "start")
            echo -e "${YELLOW}启动 $service_name...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $compose_file up -d
            ;;
        "stop")
            echo -e "${YELLOW}停止 $service_name...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $compose_file down
            ;;
        "restart")
            echo -e "${YELLOW}重启 $service_name...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $compose_file restart
            ;;
        "status")
            echo -e "${YELLOW}$service_name 状态:${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $compose_file ps
            ;;
        "logs")
            echo -e "${YELLOW}$service_name 日志:${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $compose_file logs
            ;;
        *)
            echo -e "${RED}未知命令: $command${NC}"
            show_help
            exit 1
            ;;
    esac
}

# 处理所有服务命令
handle_all_services() {
    local command=$1

    case $command in
        "start")
            echo -e "${YELLOW}启动所有核心服务...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $PORTAINER_COMPOSE up -d
            docker-compose --env-file "${ENV_FILE}" -f $DOCKGE_COMPOSE up -d
            docker-compose --env-file "${ENV_FILE}" -f $TRAEFIK_COMPOSE up -d
            echo -e "${GREEN}所有服务已启动!${NC}"
            ;;
        "stop")
            echo -e "${YELLOW}停止所有核心服务...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $TRAEFIK_COMPOSE down
            docker-compose --env-file "${ENV_FILE}" -f $DOCKGE_COMPOSE down
            docker-compose --env-file "${ENV_FILE}" -f $PORTAINER_COMPOSE down
            echo -e "${GREEN}所有服务已停止!${NC}"
            ;;
        "restart")
            echo -e "${YELLOW}重启所有核心服务...${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $PORTAINER_COMPOSE restart
            docker-compose --env-file "${ENV_FILE}" -f $DOCKGE_COMPOSE restart
            docker-compose --env-file "${ENV_FILE}" -f $TRAEFIK_COMPOSE restart
            echo -e "${GREEN}所有服务已重启!${NC}"
            ;;
        "status")
            echo -e "${YELLOW}Portainer 状态:${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $PORTAINER_COMPOSE ps
            echo -e "\n${YELLOW}Dockge 状态:${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $DOCKGE_COMPOSE ps
            echo -e "\n${YELLOW}Traefik 状态:${NC}"
            docker-compose --env-file "${ENV_FILE}" -f $TRAEFIK_COMPOSE ps
            ;;
        "logs")
            echo -e "${RED}请为logs命令指定具体服务${NC}"
            exit 1
            ;;
        *)
            echo -e "${RED}未知命令: $command${NC}"
            show_help
            exit 1
            ;;
    esac
}

# 检查是否为第一次运行
check_first_run() {
    # 检查Portainer数据目录是否存在
    local portainer_data_dir=$(grep "DATA_PATH" "${ENV_FILE}" | cut -d '=' -f2 | sed 's/[ \t]*$//')
    portainer_data_dir="${portainer_data_dir}/portainer"

    if [ ! -d "$portainer_data_dir" ]; then
        echo -e "${YELLOW}检测到首次运行，正在初始化数据目录...${NC}"

        # 创建数据目录
        mkdir -p "${portainer_data_dir}"
        mkdir -p "$(dirname "$portainer_data_dir")/dockge/data"
        mkdir -p "$(dirname "$portainer_data_dir")/traefik/config"
        mkdir -p "$(dirname "$portainer_data_dir")/traefik/letsencrypt"

        # 设置Portainer密码
        local portainer_password=$(grep "PORTAINER_PASSWORD" "${ENV_FILE}" | cut -d '=' -f2 | sed 's/[ \t]*$//')
        echo -n "$portainer_password" > "${portainer_data_dir}/portainer_password"
        chmod 600 "${portainer_data_dir}/portainer_password"

        echo -e "${GREEN}初始化完成!${NC}"
    fi
}

# 主函数
main() {
    check_docker

    # 如果没有参数，显示帮助
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    # 提取命令参数
    COMMAND=$1
    SERVICE=${2:-"all"}  # 默认为all

    # 处理help命令
    if [ "$COMMAND" == "help" ]; then
        show_help
        exit 0
    fi

    # 检查首次运行
    check_first_run

    # 根据服务类型处理命令
    if [ "$SERVICE" == "all" ]; then
        handle_all_services "$COMMAND"
    else
        handle_service "$COMMAND" "$SERVICE"
    fi
}

# 执行主函数
main "$@"
