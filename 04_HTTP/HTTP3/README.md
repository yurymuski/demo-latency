- setup ubuntu 18.04 server
- create DNS records like http3.yurets.online


```shell
DOMAIN="http3.yurets.online"
scp 04_HTTP/HTTP3/setup.sh root@$DOMAIN:/opt/
ssh root@$DOMAIN "chmod +x /opt/setup.sh && /opt/setup.sh $DOMAIN"

#checking
docker run -it --rm ymuski/curl-http3 curl -Lv https://${DOMAIN} --http3
docker run -it --rm ymuski/curl-http3 curl -Lv https://${DOMAIN}/hello --http3


docker run -it --rm ymuski/curl-http3 curl -w " time_DNS_resolved: %{time_namelookup}\n time_TCP_established: %{time_connect}\n time_TLS_handshake_done: %{time_appconnect}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_TTFB: %{time_starttransfer}\n time_total: %{time_total}\n" -o /dev/null -s https://${DOMAIN} --http3

docker run -it --rm ymuski/curl-http3 ./httpstat.sh -Lv https://${DOMAIN}  --http3
```
