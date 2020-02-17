curl 1000 requests stats:

50% stats:

**Server/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
EU response ms|137.00|30.76
Japan response ms|1,271.21|1,066.38
diff|1,134.21|1,035.62
ratio|9.28|34.66

99% stats:

**Server/User location**|**From laptop EU**|**From server EU**
:-----:|:-----:|:-----:
EU response ms|214.20|102.15
Japan response ms|1,505.57|1,125.21
diff|1,291.37|1,023.06
ratio|7.03|11.02

**Conclusion**: 
- Server responce after all tuning in demo is `7x`-`34x` faster than default configured server.
- time savings 99% laptop: `1291ms`