#!/bin/bash
set -e

# sudo apt-get install -y r-base-core docker.io

# docker run -it --rm ymuski/curl-http3 curl -w "%{time_total}\n" -o /dev/null -s "https://demo.site --http3"

for PROTOCOL in {'http3','http2'}; do
  if [ "$PROTOCOL" = "http2" ]; then
    CMD='docker run -it --rm curlimages/curl:7.68.0 curl --http2'
  else
    CMD='docker run -it --rm ymuski/curl-http3 curl --http3'
  fi
  for i in {1..1000}; do
    $CMD -w "%{time_total}\n" -o /dev/null -s "https://http3.yurets.online/hello" >> /tmp/${PROTOCOL};
  done;
  echo -e "\n\n ${PROTOCOL}";
  cat /tmp/${PROTOCOL} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.95,.99)));';
  rm /tmp/${PROTOCOL};
echo -e "================== \n";
done;