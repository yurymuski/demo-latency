- setup ubuntu 18.04 servers in different regions (eu/us/jp)
- create DNS records like REGION-demo-default.DOMAIN
  - us-demo-default.yurets.online
  - eu-demo-default.yurets.online
  - jp-demo-default.yurets.online

```shell
DOMAIN="us-demo-default.yurets.online"
scp -r 05_DEMO/demo-default root@$DOMAIN:/opt/
ssh root@$DOMAIN "chmod +x /opt/demo-default/setup.sh && /opt/demo-default/setup.sh $DOMAIN"

#checking
curl -Lv https://${DOMAIN}

curl -w " time_DNS_resolved: %{time_namelookup}\n time_TCP_established: %{time_connect}\n time_TLS_handshake_done: %{time_appconnect}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_TTFB: %{time_starttransfer}\n time_total: %{time_total}\n" -o /dev/null -s https://${DOMAIN}

docker run -it --rm ymuski/curl-http3 ./httpstat.sh -Lv https://${DOMAIN}
```