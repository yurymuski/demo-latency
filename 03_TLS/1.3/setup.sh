#!/bin/bash
set -e

add-apt-repository -y ppa:certbot/certbot && apt-get update && apt-get install -y nginx certbot python-certbot-nginx;

rm /etc/nginx/sites-enabled/default;
cat > /etc/nginx/sites-enabled/tls1.3 <<EOF
server {
        listen 80;
        server_name tls13.yurets.online;

        if (\$host != "tls13.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

#Server with TLS 1.3
server {
        server_name tls13.yurets.online;
        listen 443 ssl http2;

        #ssl_certificate      /etc/letsencrypt/live/tls13.yurets.online/fullchain.pem;
        #ssl_certificate_key  /etc/letsencrypt/live/tls13.yurets.online/privkey.pem;

        ssl_protocols TLSv1.3;

        if (\$host != "tls13.yurets.online") {
                return 404;
        }

        location / {
                return 200 "hello TLS 1.3\n";
                add_header Content-Type text/plain;
        }
}
EOF

certbot certonly --nginx --non-interactive --agree-tos -d tls13.yurets.online -m your_email@gmail.com
sed -i 's/#ssl_/ssl_/g' /etc/nginx/sites-enabled/tls1.3
service nginx reload