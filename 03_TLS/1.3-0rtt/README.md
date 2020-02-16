Checking TLS early data 0-rrt
```
host=tls13-0rtt.yurets.online # replace with your server name
echo -e "HEAD / HTTP/1.1\r\nHost: $host\r\nConnection: close\r\n\r\n" > request.txt
openssl s_client -connect $host:443 -tls1_3 -sess_out session.pem -ign_eof < request.txt
openssl s_client -connect $host:443 -tls1_3 -sess_in session.pem -early_data request.txt
```
`Early data was accepted` 