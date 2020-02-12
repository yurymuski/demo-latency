#!/bin/bash
set -e

add-apt-repository -y ppa:certbot/certbot && \
apt-get update && \
apt-get install -y certbot docker.io;

certbot certonly --standalone --non-interactive --agree-tos -d eu.yurets.online -m muski.yury@gmail.com
certbot certonly --standalone --non-interactive --agree-tos -d demo.yurets.online -m muski.yury@gmail.com

docker pull ranadeeppolavarapu/nginx-http3

echo "Hello Demo EU" > /opt/nginx/files/index.html

mkdir -p /opt/nginx/conf

cat > /opt/nginx/conf/nginx.conf <<EOF

events {
    worker_connections  1024;
}

http {
        include         /etc/nginx/mime.types;
        include         /etc/nginx/conf.d/*.conf;

        ssl_session_timeout 1d;
        ssl_session_cache shared:MozSSL:10m;  # about 40000 sessions
        ssl_session_tickets off;

        # modern configuration
        ssl_protocols TLSv1.3;
        ssl_prefer_server_ciphers off;

        # OCSP stapling
        ssl_stapling on;
        ssl_stapling_verify on;

        brotli_static on;
        brotli on;

}

EOF

cat > /opt/nginx/conf/eu.conf <<EOF
server {
        listen 80;
        server_name eu.yurets.online;

        if (\$host != "eu.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

server {
        # Enable QUIC and HTTP/3.
        listen 443 quic reuseport;

        # Enable HTTP/2 (optional).
        listen 443 ssl http2;

        server_name eu.yurets.online;

        ssl_certificate      /opt/nginx/certs/live/eu.yurets.online/fullchain.pem;
        ssl_certificate_key  /opt/nginx/certs/live/eu.yurets.online/privkey.pem;
        ssl_trusted_certificate /opt/nginx/certs/live/eu.yurets.online/fullchain.pem;

        # Enable all TLS versions (TLSv1.3 is required for QUIC).

        ssl_early_data on;

        #proxy_set_header Early-Data \$ssl_early_data;

        if (\$host != "eu.yurets.online") {
                return 404;
        }

        # Add Alt-Svc header to negotiate HTTP/3.
        add_header alt-svc 'h3-24=":443"; ma=86400, h3-23=":443"; ma=86400';

        location /hello {
                return 200 "hello nginx latency-optimized config EU-demo server\n";
                add_header Content-Type text/plain;
        }
        location / {
                root   /usr/share/nginx/html;
                index  index.html;
        }
}

EOF

cat > /opt/nginx/conf/demo.conf <<EOF
server {
        listen 80;
        server_name demo.yurets.online;

        if (\$host != "demo.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

server {
        # Enable QUIC and HTTP/3.
        listen 443 quic;

        # Enable HTTP/2 (optional).
        listen 443 ssl http2;

        server_name demo.yurets.online;

        ssl_certificate      /opt/nginx/certs/live/demo.yurets.online/fullchain.pem;
        ssl_certificate_key  /opt/nginx/certs/live/demo.yurets.online/privkey.pem;
        ssl_trusted_certificate /opt/nginx/certs/live/demo.yurets.online/fullchain.pem;

        # Enable all TLS versions (TLSv1.3 is required for QUIC).
        ssl_protocols TLSv1.3;

        ssl_early_data on;

        #proxy_set_header Early-Data \$ssl_early_data;

        if (\$host != "demo.yurets.online") {
                return 404;
        }

        # Add Alt-Svc header to negotiate HTTP/3.
        add_header alt-svc 'h3-24=":443"; ma=86400, h3-23=":443"; ma=86400';

        location /hello {
                return 200 "hello nginx latency-optimized config EU-demo server\n";
                add_header Content-Type text/plain;
        }
        location / {
                root   /usr/share/nginx/html;
                index  index.html;
        }
}

EOF

docker run --name nginx -d --net host -v /etc/letsencrypt/:/opt/nginx/certs/  -v /opt/nginx/conf/eu.conf:/etc/nginx/conf.d/eu.conf -v /opt/nginx/conf/demo.conf:/etc/nginx/conf.d/demo.conf -v /opt/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /opt/nginx/files/:/usr/share/nginx/html/   ranadeeppolavarapu/nginx-http3

#checking
docker run -it --rm ymuski/curl-http3 curl -ILv https://eu.yurets.online --http3

docker run -it --rm ymuski/curl-http3 curl  -w "time_DNS_resolved: %{time_namelookup}, time_TCP_established: %{time_connect}, time_TLS_handshake_done: %{time_appconnect}, time_pretransfer: %{time_pretransfer}, time_redirect: %{time_redirect}, time_TTFB: %{time_starttransfer}, time_total: %{time_total}\n" -o /dev/null -s https://eu.yurets.online --http3 
