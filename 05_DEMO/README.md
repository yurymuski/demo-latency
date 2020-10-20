Test:
```shell
CLIENT_IP='5.188.114.136'
scp 05_DEMO/demo_check.sh root@$CLIENT_IP:/opt/
ssh root@$CLIENT_IP "chmod +x /opt/demo_check.sh"


# default servers check
for DOMAIN in {'us-demo-default.yurets.online','eu-demo-default.yurets.online','jp-demo-default.yurets.online'}; do ssh root@$CLIENT_IP "/opt/demo_check.sh $DOMAIN 'curl'"; done;


# tuned servers check with HTTP3
for DOMAIN in {'us-demo-tuned.yurets.online','eu-demo-tuned.yurets.online','jp-demo-tuned.yurets.online'}; do ssh root@$CLIENT_IP "/opt/demo_check.sh $DOMAIN 'curl --http3'"; done;

```


### Stats: 
curl 1000 requests stats from MSK server:

 stats:

**Server response ms**|**50%**|**95%**|**99%**
:-----:|:-----:|:-----:|:-----:
EU tuned|105|109|122
EU default|213|219|228
Japan tuned|536|544|554
Japan default|1076|1091|1102


**Conclusion**: 
- Tuned server is 2x faster in same region
- Tuned + GEO server is 10x faster
- Benefit can be over 1 second