**NOTE: Add firewall rule for 443/udp**

Test:
```shell
CLIENT_IP=''
DOMAIN="http3.yurets.online"
scp 04_HTTP/http_check.sh root@$CLIENT_IP:/opt/
ssh root@$CLIENT_IP "chmod +x /opt/http_check.sh"
ssh root@$CLIENT_IP "/opt/http_check.sh $DOMAIN"


```

### Stats:
HTTP2 vs HTTP3 curl 1000 requests stats from RU and US server:


50% stats:

**HTTP Protocol/User location**|**From server RU**|**From server US**
:-----:|:-----:|:-----:
HTTP2 JP response ms|813|392
HTTP3 JP response ms|537|297
ratio|1.51|1.32

99% stats:

**HTTP Protocol/User location**|**From server RU**|**From server US**
:-----:|:-----:|:-----:
HTTP2 JP response ms|828|419
HTTP3 JP response ms|552|368
ratio|1.5|1.14

**Conclusion**: 
- HTTP3 response is `1.14x`-`1.51x` faster than HTTP2.