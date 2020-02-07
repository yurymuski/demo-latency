#!/bin/bash
set -e

add-apt-repository -y ppa:certbot/certbot && apt-get update && apt-get install -y nginx certbot python-certbot-nginx;

rm /etc/nginx/sites-enabled/default;
cat > /etc/nginx/sites-enabled/jp <<EOF
server {
        listen 80;
        server_name jp.yurets.online;

        if (\$host != "jp.yurets.online") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

server {
        server_name jp.yurets.online;
        listen 443 ssl;

        #ssl_certificate      /etc/letsencrypt/live/jp.yurets.online/fullchain.pem;
        #ssl_certificate_key  /etc/letsencrypt/live/jp.yurets.online/privkey.pem;

        if (\$host != "jp.yurets.online") {
                return 404;
        }

        location / {
                return 200 "hello nginx default config JP server\n";
                add_header Content-Type text/plain;
        }
}
EOF

certbot certonly --nginx --non-interactive --agree-tos -d jp.yurets.online -m muski.yury@gmail.com
sed -i 's/#ssl_/ssl_/g' /etc/nginx/sites-enabled/jp
service nginx reload