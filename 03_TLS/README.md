curl 1000 requests stats:

50% stats:

**Server/User location**|**From laptop EU**|**From server JP**
:-----:|:-----:|:-----:
TLS 1.2 JP response ms|612.99|24.81
TLS 1.3 JP response ms|306.66|9.59
diff|306.33|15.22
ratio|199.89%|258.65%

99% stats:

**Server/User location**|**From laptop EU**|**From server JP**
:-----:|:-----:|:-----:
TLS 1.2 JP response ms|716.15|26.65
TLS 1.3 JP response ms|376.38|16.60
diff|339.77|10.05
ratio|190.27%|160.57%

**Conclusion**: 
- `TLS 1.3` is `1.6x`-`2.6x` faster than `TLS 1.2`.
- time savings 99% laptop: `339ms`