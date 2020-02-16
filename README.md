# demo-latency

## checking NS responce

`dig +trace google.com @8.8.8.8 | tail -n2 | grep -i received`
```
;; Received 55 bytes from 216.239.32.10#53(ns1.google.com) in 35 ms
```

## checking latency with `curl` (result in seconds)

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

`curl -w "@curl-format.txt" -L -o /dev/null -s "https://google.com/"`

```
time_DNS_resolved:  0.151635
time_TCP_established:  0.473644
time_TLS_handshake_done:  0.579267
time_pretransfer:  0.579403
time_redirect:  0.473711
time_TTFB:  0.883309
----------
time_total:  0.916728
```

## reuse session
`curl -w "@curl-format.txt" -L -o /dev/null -s "https://google.com/"  -o /dev/null/ "https://google.com/"`
```
time_DNS_resolved:  0.002012
time_TCP_established:  0.053303
time_TLS_handshake_done:  0.174710
time_pretransfer:  0.174917
time_redirect:  0.153164
time_TTFB:  0.300262
----------
time_total:  0.303981
time_DNS_resolved:  0.000096
time_TCP_established:  0.000101
time_TLS_handshake_done:  0.000103
time_pretransfer:  0.000300
time_redirect:  0.073336
time_TTFB:  0.139116
----------
time_total:  0.139482
```

## usefull tool visualization: `httpstat`
`httpstat -Lv https://google.com/`

![](httpstat.png?raw=true)

## HTTP 3 checking

`docker run -it --rm ymuski/curl-http3 curl -ILv https://blog.cloudflare.com --http3`

```
* Sent QUIC client Initial, ALPN: h3-25h3-24h3-23
* h3 [:method: HEAD]
* h3 [:path: /]
* h3 [:scheme: https]
* h3 [:authority: blog.cloudflare.com]
* h3 [user-agent: curl/7.69.0-DEV]
* h3 [accept: */*]
* Using HTTP/3 Stream ID: 0 (easy handle 0x5569a53b2780)
> HEAD / HTTP/3
> Host: blog.cloudflare.com
> user-agent: curl/7.69.0-DEV
> accept: */*
> 
< HTTP/3 200
HTTP/3 200
```
Checking latency:

`docker run -it --rm ymuski/curl-http3 curl -w " time_DNS_resolved: %{time_namelookup}\n time_TCP_established: %{time_connect}\n time_TLS_handshake_done: %{time_appconnect}\n time_pretransfer: %{time_pretransfer}\n time_redirect: %{time_redirect}\n time_TTFB: %{time_starttransfer}\n time_total: %{time_total}\n" -o /dev/null -s https://blog.cloudflare.com --http3`

```
 time_DNS_resolved: 0.036634
 time_TCP_established: 0.000000
 time_TLS_handshake_done: 0.000000
 time_pretransfer: 0.084228
 time_redirect: 0.000000
 time_TTFB: 0.112559
 time_total: 0.136620
```
Checking latency with httpstat:

`docker run -it --rm ymuski/curl-http3 ./httpstat.sh -ILv https://blog.cloudflare.com --http3`

![](https://raw.githubusercontent.com/yurymuski/curl-http3/master/httpstat.png)