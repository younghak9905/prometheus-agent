#!/bin/bash

# 루트 권한 확인
if [ "$EUID" -ne 0 ]
  then echo "루트 권한이 필요합니다."
  exit
fi

# 사용자에게 Loki 서버의 IP 주소 입력 받기
read -p "Loki 서버의 IP 주소를 입력하세요 (예:192.123.123.123): " ip_address

# 입력 확인
if [[ -z "$ip_address" ]]; then
    echo "IP 주소를 입력하지 않았습니다. 스크립트를 종료합니다."
    exit 1
fi

echo "LOKI_URL=http://${ip_address}:3100/loki/api/v1/push" > docker/.env


loki_url="http://${ip_address}:3100/loki/api/v1/push"

# /etc/docker 디렉터리가 없는 경우 생성
mkdir -p /etc/docker

# /etc/docker/daemon.json 파일에 설정 쓰기
cat <<EOL > /etc/docker/daemon.json
{
    "debug" : true,
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "$loki_url"
    }
}
EOL

sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions

sudo systemctl restart docker

docker plugin ls

# 수정된 daemon.json 파일의 내용 출력
cat /etc/docker/daemon.json

echo "daemon.json 파일이 수정되었으며, Docker 데몬이 재시작되었습니다. Loki 서버의 IP 주소가 맞는 지 확인해주세요"
