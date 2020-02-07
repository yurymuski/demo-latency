# demo-latency

checking latency with `curl` (result in seconds):
```
cat > curl-format.txt <<EOF
time_DNS_resolved:  %{time_namelookup}\n
time_TCP_established:  %{time_connect}\n
time_TLS_handshake_done:  %{time_appconnect}\n
time_pretransfer:  %{time_pretransfer}\n
time_redirect:  %{time_redirect}\n
time_TTFB:  %{time_starttransfer}\n
----------\n
time_total:  %{time_total}\n
EOF
```
```
curl -w "@curl-format.txt" -L -o /dev/null -s "https://google.com/"
```
reuse session:
```
curl -w "@curl-format.txt" -L -o /dev/null -s "https://google.com/"  -o /dev/null/ "https://google.com/" 
```

also usefull tool: `httpstat`
```
httpstat https://google.com/
```