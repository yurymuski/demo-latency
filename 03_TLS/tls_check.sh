#!/bin/bash
set -ex

apt-get update && apt-get install -y r-base-core curl gawk

# curl -w "%{time_namelookup},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_redirect},%{time_starttransfer},%{time_total}\n" -o /dev/null -s "https://demo.site"

for DOMAIN in {'tls12.yurets.online','tls13.yurets.online'}; do
  # rm stats file if exists
  [ -e /tmp/${DOMAIN} ] && rm /tmp/${DOMAIN};
  [ -e /tmp/${DOMAIN}.csv ] && rm /tmp/${DOMAIN}.csv;

  #echo "time_DNS_resolved,time_TCP_established,time_TLS_handshake_done,time_pretransfer,time_redirect,time_TTFB,time_total" > /tmp/${DOMAIN}.csv
  for i in {1..1000}; do
    curl -w "%{time_namelookup},%{time_connect},%{time_appconnect},%{time_pretransfer},%{time_redirect},%{time_starttransfer},%{time_total}\n" -o /dev/null -s "https://${DOMAIN}" >> /tmp/${DOMAIN}.csv;
  done;
  awk -F , '{print ($3 - $2)*1000}' /tmp/${DOMAIN}.csv >> /tmp/${DOMAIN}
  echo -e "\n\n ${DOMAIN}";
  cat /tmp/${DOMAIN} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.99)));';
echo -e "================== \n";
done;