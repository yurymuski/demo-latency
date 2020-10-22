#!/bin/bash
set -ex

DOMAIN=$1
apt-get update && apt-get install -y r-base-core docker.io

# docker run -it --rm ymuski/curl-http3 curl -w "%{time_total}\n" -o /dev/null -s "https://demo.site --http3"

for PROTOCOL in {'http3','http2'}; do
  # rm stats file if exists
  [ -e /tmp/${PROTOCOL} ] && rm /tmp/${PROTOCOL};
  if [ "$PROTOCOL" = "http2" ]; then
    CMD='docker run -i --rm curlimages/curl:7.68.0 curl --http2'
  else
    CMD='docker run -i --rm ymuski/curl-http3 curl --http3'
  fi
  for i in {1..1000}; do
    $CMD -w "%{time_total}\n" -o /dev/null -s "https://${DOMAIN}" >> /tmp/${PROTOCOL};
  done;
  echo -e "\n\n ${PROTOCOL}";
  cat /tmp/${PROTOCOL} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.95,.99)));' > /tmp/${PROTOCOL}-results;
  echo -e "================== \n";
done;