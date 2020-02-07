#!/bin/bash
set -e

add-apt-repository 'deb http://nginx.org/packages/ubuntu/ bionic nginx' && \
wget https://nginx.org/keys/nginx_signing.key -O - | sudo apt-key add - && \
add-apt-repository -y ppa:certbot/certbot && \
apt-get update && \
apt-get install -y nginx certbot python-certbot-nginx;

rm /etc/nginx/conf.d/default.conf;
cat > /etc/nginx/conf.d/tls1.3-0rtt.conf <<EOF
server {
        listen 80;
        server_name tls13-0rtt.yurets.online;

        if (\$host != "tls13-0rtt.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

#Server with TLS 1.3 0-rtt
server {
        server_name tls13-0rtt.yurets.online;
        listen 443 ssl;

        #ssl_certificate      /etc/letsencrypt/live/tls13-0rtt.yurets.online/fullchain.pem;
        #ssl_certificate_key  /etc/letsencrypt/live/tls13-0rtt.yurets.online/privkey.pem;

        ssl_protocols TLSv1.3;
        ssl_early_data on;

        proxy_set_header Early-Data \$ssl_early_data;

        if (\$host != "tls13-0rtt.yurets.online") {
                return 404;
        }

        location / {
                return 200 "hello TLS 1.3 0rtt\n";
                add_header Content-Type text/plain;
        }
}
EOF

certbot certonly --nginx --non-interactive --agree-tos -d tls13-0rtt.yurets.online -m muski.yury@gmail.com
sed -i 's/#ssl_/ssl_/g' /etc/nginx/conf.d/tls1.3-0rtt.conf
sed -i 's/listen 443;/listen 443 ssl;/g' /etc/nginx/conf.d/tls1.3-0rtt.conf
service nginx reload