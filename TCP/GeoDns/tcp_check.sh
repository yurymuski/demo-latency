#!/bin/bash
set -e

# sudo apt-get install -y r-base-core curl

# NOTE: add dns records to /etc/hosts to avoid DNS latency

# curl -w "%{time_connect}\n" -o /dev/null -s "http://demo.site"

for DOMAIN in {'demo.jp','demo.eu'}; do
  for i in {1..1000}; do
    curl -w "%{time_connect}\n" -o /dev/null -s "http://${DOMAIN}" >> /tmp/${DOMAIN};
  done;
  echo -e "\n\n ${DOMAIN}";
  cat /tmp/${DOMAIN} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.99)));';
  rm /tmp/${DOMAIN};
echo -e "================== \n";
done;
