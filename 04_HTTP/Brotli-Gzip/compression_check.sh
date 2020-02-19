#!/bin/bash
set -e

# sudo apt-get install -y r-base-core curl

for compression in {'','gzip','brotli'}; do
  #Check file size
  curl -w "%{size_download}" -o /dev/null -s -H 'Accept-Encoding: gzip, br' "https://http3.yurets.online/$compression/demo.json" 
  for i in {1..1000}; do
    curl -w "%{time_total}\n" -o /dev/null -s -H 'Accept-Encoding: gzip, br' "https://http3.yurets.online/$compression/demo.json" >> /tmp/${compression}.txt;
  done;
  echo -e "\n\n ${compression}";
  cat /tmp/${compression}.txt | Rscript -e 'stat=(scan("stdin")); print(quantile(stat, c(.50,.95,.99)));';
  rm /tmp/${compression}.txt;
echo -e "================== \n";
done;