#!/bin/bash
set -ex

DOMAIN=$1
CURL=$2

apt-get update && apt-get install -y r-base-core docker.io

# docker run -it --rm ymuski/curl-http3 curl -w "%{time_total}\n" -o /dev/null -s "https://demo.site --http3"
# test domain response
docker run -i --rm ymuski/curl-http3 $CURL -s https://$DOMAIN
docker run -i --rm ymuski/curl-http3 ./httpstat.sh -Lv https://$DOMAIN

# rm stats file if exists
[ -e /tmp/${DOMAIN} ] && rm /tmp/${DOMAIN};

for i in {1..1000}; do
  docker run -i --rm ymuski/curl-http3 $CURL -w "%{time_total}\n" -o /dev/null -s "https://${DOMAIN}" >> /tmp/${DOMAIN};
done;
echo -e "\n\n ${DOMAIN}";
cat /tmp/${DOMAIN} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.95,.99)));' > /tmp/${DOMAIN}-results;

echo -e "================== \n";
