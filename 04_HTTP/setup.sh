#!/bin/bash
set -e

add-apt-repository -y ppa:certbot/certbot && \
apt-get update && \
apt-get install -y certbot docker.io;

systemctl enable docker --now;

certbot certonly --standalone --non-interactive --agree-tos -d http3.yurets.online -m muski.yury@gmail.com

docker pull ymuski/nginx-quic

mkdir -p /opt/nginx/files/{gzip,brotli}
wget -O /opt/nginx/files/demo.json http://www.json-generator.com/api/json/get/cpluFyieMi?indent=2
echo "Hello HTTP3" > /opt/nginx/files/index.html

ln -sf ../demo.json /opt/nginx/files/brotli/demo.json
ln -sf ../demo.json /opt/nginx/files/gzip/demo.json

mkdir -p /opt/nginx/conf
cat > /opt/nginx/conf/nginx.conf <<EOF

events {
    worker_connections  1024;
}

http {
        include         /etc/nginx/mime.types;
        include         /etc/nginx/conf.d/*.conf;
}

EOF

cat > /opt/nginx/conf/http3.conf <<EOF
server {
        listen 80;
        server_name http3.yurets.online;

        if (\$host != "http3.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

server {
        # Enable QUIC and HTTP/3.
        listen 443 quic reuseport;

        # Enable HTTP/2 (optional).
        listen 443 ssl http2;

        server_name http3.yurets.online;

        ssl_certificate      /opt/nginx/certs/live/http3.yurets.online/fullchain.pem;
        ssl_certificate_key  /opt/nginx/certs/live/http3.yurets.online/privkey.pem;

        # Enable all TLS versions (TLSv1.3 is required for QUIC).
        ssl_protocols TLSv1.3;

        ssl_early_data on;

        #proxy_set_header Early-Data \$ssl_early_data;

        if (\$host != "http3.yurets.online") {
                return 404;
        }

        # Add Alt-Svc header to negotiate HTTP/3.
        add_header alt-svc 'h3-27=":443"; ma=86400';

        location / {
                root   /usr/share/nginx/html;
                index  index.html;
        }

        location /hello {
                return 200 "hello HTTP3\n";
                add_header alt-svc 'h3-27=":443"; ma=86400';
                add_header Content-Type text/plain;
        }

        location /brotli/ {
                root   /usr/share/nginx/html;
                index  index.html;

                brotli_static on;
                brotli on;
                brotli_types application/json;
        }

        location /gzip/ {
                root   /usr/share/nginx/html;
                index  index.html;

                gzip on;
                gzip_vary on;
                gzip_proxied any;
                gzip_types application/json;
        }
}

EOF

docker run --name nginx --restart always -d -p 80:80 -p 443:443/tcp -p 443:443/udp -v /etc/letsencrypt/:/opt/nginx/certs/  -v /opt/nginx/conf/http3.conf:/etc/nginx/conf.d/http3.conf -v /opt/nginx/conf/nginx.conf:/etc/nginx/nginx.conf -v /opt/nginx/files/:/usr/share/nginx/html/ ymuski/nginx-quic

#checking
docker run -it --rm ymuski/curl-http3 curl -Lv https://http3.yurets.online --http3
docker run -it --rm ymuski/curl-http3 curl -Lv https://http3.yurets.online/hello --http3