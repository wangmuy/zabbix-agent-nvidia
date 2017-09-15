zabbix-agent for monitoring nvidia-gpu

from [RichardKav/zabbix-nvidia-smi-integration](https://github.com/RichardKav/zabbix-nvidia-smi-integration)

1. prepare zabbix db/server/web:

```
# db
docker run --name zabbix-db -d -e MYSQL_USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_ROOT _PASSWORD=zabbix mysql
# server
docker run --name zabbix-server -e DB_SERVER_HOST="zabbix-db" -e MYSQL_USER=zabbix -e MYSQ L_PASSWORD=zabbix -e MYSQL_DATABASE=zabbix -e MYSQL_ROOT_PASSWORD=zabbix --link zabbix-db:mysql -p 10051:10051 -it zabbix/zabbix-server-mysql # may take longer time
# web
docker run --name zabbix-web -e DB_SERVER_HOST=zabbix-db -e MYSQL_DATABASE=zabbix -e MYSQL _USER=zabbix -e MYSQL_PASSWORD=zabbix -e MYSQL_ROOT_PASSWORD=zabbix --link zabbix-db:mysql --link zabbix-server:zabbix-server -p 8000:80 -it zabbix/zabbix-web-nginx-mysql # username:Admin pwd:zabbix
```

2. start agent:

```
nvidia-docker run -d -p 50050:10050 -e HOSTNAME=gpumonitoragent -e ALLOW_HOST='1727.0.3,172.17.0.1' zabbix-agent-nvidia
```

3. Config via web:

3.1 Add template

Configuration -> Templates -> Import [nvidia_smi_template.xml](https://github.com/RichardKav/zabbix-nvidia-smi-integration/blob/master/nvidia_smi_template.xml)

3.2 Add host

Configuration -> Hosts -> Create host, set "Host name", "IP address" and "Port"

Make sure "Host name" is the same as agent docker run param HOSTNAME
