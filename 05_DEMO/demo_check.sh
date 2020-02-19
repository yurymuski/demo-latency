#!/bin/bash
set -e

# sudo apt-get install -y r-base-core docker.io

# docker run -it --rm ymuski/curl-http3 curl -w "%{time_total}\n" -o /dev/null -s "https://demo.site --http3"

for DOMAIN in {'eu.yurets.online','jp.yurets.online'}; do
  if [ "$DOMAIN" = "eu.yurets.online" ]; then
    CURL='curl --http3'
  else
    CURL='curl'
  fi
  # test domain response
  docker run -it --rm ymuski/curl-http3 $CURL https://$DOMAIN
  for i in {1..1000}; do
    docker run -it --rm ymuski/curl-http3 $CURL -w "%{time_total}\n" -o /dev/null -s "https://${DOMAIN}" >> /tmp/${DOMAIN};
  done;
  echo -e "\n\n ${DOMAIN}";
  cat /tmp/${DOMAIN} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.95,.99)));';
  rm /tmp/${DOMAIN};
echo -e "================== \n";
done;