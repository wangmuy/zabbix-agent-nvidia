FROM nvidia/cuda:8.0-runtime-ubuntu16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget
RUN pkg="zabbix-release_3.0-1+xenial_all.deb" \
  && wget http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/$pkg -O /tmp/zabbix-agent.deb \
  && dpkg -i /tmp/zabbix-agent.deb
RUN apt-get update && apt-get install -y zabbix-agent && apt-get clean
RUN export conf_file=/etc/zabbix/zabbix_agentd.conf \
  && echo 'AllowRoot=1' >> $conf_file
ADD UserParameter.nvidia /UserParameter.nvidia
RUN cat /UserParameter.nvidia >> /etc/zabbix/zabbix_agentd.conf
RUN echo gpuMonitorAgent > /etc/hostname

ADD start.sh /start.sh
RUN chmod 777 /start.sh
CMD /start.sh
