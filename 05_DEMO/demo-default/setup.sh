#!/bin/bash
set -ex

DOMAIN=$1

add-apt-repository -y ppa:certbot/certbot && \
apt-get update && \
apt-get install -y nginx certbot python-certbot-nginx;

[ -e /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default;

echo "Hello Demo ${DOMAIN}" > /var/www/html/index.html

cat > /etc/nginx/sites-enabled/demo-default <<EOF
server {
        listen 80;
        server_name ${DOMAIN};

        if (\$host != "${DOMAIN}") {
                return 404;
        }

        return 301 https://\$host\$request_uri;
}

server {
        server_name ${DOMAIN};
        listen 443 ssl;

        #ssl_certificate      /etc/letsencrypt/live/${DOMAIN}/fullchain.pem;
        #ssl_certificate_key  /etc/letsencrypt/live/${DOMAIN}/privkey.pem;

        if (\$host != "${DOMAIN}") {
                return 404;
        }

        location /hello {
                return 200 "hello nginx default config ${DOMAIN} server\n";
                add_header Content-Type text/plain;
        }

        location / {
                root   /var/www/html;
                index  index.html;
        }
}
EOF

certbot certonly --nginx --non-interactive --agree-tos -d ${DOMAIN} -m your_email@gmail.com
sed -i 's/#ssl_/ssl_/g' /etc/nginx/sites-enabled/demo
service nginx reload