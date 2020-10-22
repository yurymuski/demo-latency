#!/bin/bash
set -ex

apt-get update && apt-get install -y r-base-core dnsutils

# example:
# dig +trace google.com @8.8.8.8 | tail -n2 | grep -i received
# for i in {1..1000}; do dig +trace google.com @8.8.8.8 | tail -n2 | grep -i received | awk {'print $8'} >> /tmp/google.com; done && cat /tmp/google.com | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.99)));' && rm /tmp/google.com

for DOMAIN in {'google.com','netflix.com','microsoft.com','cloudflare.com','hoster.by','reg.ru','freedns.afraid.org'}; do
  for RESOLVER in {'8.8.8.8','1.1.1.1','9.9.9.9','208.67.222.222'}; do
    for i in {1..1000}; do
      dig +trace ${DOMAIN} @8.8.8.8 | tail -n2 | grep -i received | awk {'print $8'} >> /tmp/${DOMAIN};
    done;
    echo -e "\n\n ${DOMAIN} : ${RESOLVER}";
    cat /tmp/${DOMAIN} | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.99)));';
    rm /tmp/${DOMAIN};
  done;
  echo -e "================== \n";
done;