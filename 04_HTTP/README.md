### **Add firewall rule for 443/udp**

### HTTP2 vs HTTP3 curl 1000 requests stats:

50% stats:

**Server/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
http2 response ms|892.27|770.06
http3 response ms|576.82|509.34
ratio|1.55|1.51

99% stats:

**Server/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
http2 response ms|1,916.11|823.82
http3 response ms|1,318.27|608.38
ratio|1.45|1.35

**Conclusion**: 
- HTTP3 responce is `1.35x`-`1.55x` faster than HTTP2.