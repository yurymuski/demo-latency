- setup ubuntu 18.04 servers in different regions (eu/us/jp)
- create DNS records like REGION-demo-tuned.DOMAIN
  - us-demo-tuned.yurets.online
  - eu-demo-tuned.yurets.online
  - jp-demo-tuned.yurets.online

```shell
DOMAIN="us-demo-tuned.yurets.online"
scp -r 05_DEMO/demo-tuned root@$DOMAIN:/opt/
ssh root@$DOMAIN "chmod +x /opt/demo-tuned/setup.sh && /opt/demo-tuned/setup.sh $DOMAIN"

#checking
docker run -it --rm ymuski/curl-http3 curl -Lv https://${DOMAIN} --http3

docker run -it --rm ymuski/curl-http3 curl -w " time_DNS_resolved: %{time_namelookup}\n time_TCP_established: %{time_connect}\n time_TLS_handshake_done: %{time_appconnect}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_TTFB: %{time_starttransfer}\n time_total: %{time_total}\n" -o /dev/null -s https://${DOMAIN} --http3

docker run -it --rm ymuski/curl-http3 ./httpstat.sh -Lv https://${DOMAIN}  --http3
```