curl 1000 requests stats:

50% stats:
**FROM/TLS**|**aws server**|**laptop**
:-----:|:-----:|:-----:
tls12|27.87|124.90
tls13|16.01|68.18
diff|11.86|56.72
ratio|174.09%|183.20%

99% stats:
**FROM/TLS**|**aws server**|**laptop**
:-----:|:-----:|:-----:
tls12|31.17|199.95
tls13|18.46|128.42
diff|12.71|71.53
ratio|168.89%|155.70%

**Conclusion**: 
- `TLS 1.3` is `1.55x`-`1.83x` faster than `TLS 1.2`.
- time savings 99% laptop: `71ms`