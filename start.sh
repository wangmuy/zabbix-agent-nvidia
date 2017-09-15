#!/bin/sh
conf_file=/etc/zabbix/zabbix_agentd.conf
[ -n "$HOSTNAME" ] \
  && sed "s/^Hostname=.*/Hostname=$HOSTNAME/g" -i $conf_file \
  && echo $HOSTNAME > /etc/hostname \
  && echo 127.0.0.1'\t'$HOSTNAME'\n' >> /etc/hosts \
  && echo "Hostname set to $HOSTNAME"
[ -n "$ALLOW_HOST" ] \
  && sed "s/^Server=.*/Server=127.0.0.1,$ALLOW_HOST/g" -i $conf_file \
  && sed "s/^ServerActive=.*/ServerActive=127.0.0.1,$ALLOW_HOST/g" -i $conf_file \
  && echo "AllowHost add $ALLOW_HOST"

service zabbix-agent restart
echo "running..."
tail -f /dev/null
