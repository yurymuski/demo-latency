### **Add firewall rule for 443/udp**

### HTTP2 vs HTTP3 curl 1000 requests stats:

50% stats:

**HTTP Protocol/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
http2 response ms|892.27|770.06
http3 response ms|576.82|509.34
ratio|1.55|1.51

99% stats:

**HTTP Protocol/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
http2 response ms|1,916.11|823.82
http3 response ms|1,318.27|608.38
ratio|1.45|1.35

**Conclusion**: 
- HTTP3 response is `1.35x`-`1.55x` faster than HTTP2.

### Compression

check file size:

`curl -s  -o /dev/null -H 'Accept-Encoding: gzip, br' "https://demo.site/gzip/demo.json" -w "%{size_download}"`

compression|size kb
:-----:|:-----:
None|137
Gzip 1 lvl|38.7
Brotli 0 lvl|42.2
Gzip 5 lvl|32.9
Brotli 6 lvl|29.7
Gzip 9 lvl|31.5
Brotli 11 lvl|25.8

- Gzip compresses **1.09x** better on **min** compression
- Brotli compresses **1.11x** better on **avg** compression
- Brotli compresses **1.21x** better on **max** compression

### Compression response curl 1000 requests stats:


Compression response sec / User location|From laptop EU|From server EU
:-----:|:-----:|:-----:
not compressed|	2.04|	1.56
gzip min compression| 	1.52|	1.06
brotli min compression| 	1.62|	1.26
gzip avg compression| 	1.63|	1.04
brotli avg compression| 	1.63|	1.04
gzip max compression| 	2.16|	1.06
brotli max compression| 	3.26|	1.38
ratio min|	1.07|	1.19
ratio avg|	1.00|	1.00
ratio max|	1.51|	1.30


- On **min** compression lvl gzip is **1.07-1.19x** faster than brotli
- On **avg** compression lvl gzip and brotli are **same speed**
- On **max** compression lvl gzip is **1.3-1.51x** faster than brotli