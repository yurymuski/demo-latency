### Stats:
curl 1000 requests stats from RU and US server:


50% stats:

**Server/User location**|**From server RU**|**From server US**
:-----:|:-----:|:-----:
TLS 1.2 JP response ms|541|257
TLS 1.3 JP response ms|275|132
diff|266|125
ratio|196.7%|194.7%

99% stats:

**Server/User location**|**From laptop EU**|**From server JP**
:-----:|:-----:|:-----:
TLS 1.2 JP response ms|550|267
TLS 1.3 JP response ms|280|136
diff|270|131
ratio|196.4%|196.3%

**Conclusion**: 
- `TLS 1.3` is `2x` faster than `TLS 1.2` - 1 RTT benefit
- time savings 99%: `270ms`