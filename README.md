# prometheus-agent
서버 모니터링을 위한 prometheus-agent 입니다. 관리 하고 싶은 서버 도커에 올려 사용합니다.

### 구성
```sh
docker-cadvisor-1  : 도커 컨테이너를 모니터링 합니다.
docker-promtail-1  : 도커의 로그를 수집합니다. ( log, gz, zip)
docker-blackbox-1  : health-check를 합니다.
docker-node-exporter-1 : CPU 정보 등을 수집합니다. 
```


### install prometheus-agent
```sh
cd /srv
sudo chown <USERNAME>:<USERNAME> ./
git clone https://github.com/ZIEN-TF/prometheus-agent.git
cd prometheus-agent
```

### log setting
```sh
sudo ./log.sh
#Inpu Loki IP Address
cd docker
sudo vi dockerfile/config/promtail.yml
```

### promtail.yml
```sh
clients:
  - url: http://loki_ip_address:3100/loki/api/v1/push      #loki 서버 IP
    batchsize: 100
scrape_configs:
  - job_name: system
    static_configs:
    - targets:  # 이 줄이 올바르게 들여쓰기되었습니다.
       - target_server_address                            # 현재 서버 IP
      labels:
         job: target_server_name                          # 구분을 위해 수정해주세요
         __path__: /var/log/*log
```

### compose up

```sh
sudo vi .env #loki-server-ip-address
sudo ./run.sh

sudo docker logs --follow {promtail_container_id}
```




### prometheus - setting

