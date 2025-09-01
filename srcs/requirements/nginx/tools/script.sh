#!/bin/bash

#echo "Waiting for WordPress PHP-FPM..."
#until nc -z wordpress 9000; do
#  echo "WordPress is not yet ready. Waiting..."
#  sleep 1
#done
#echo "WordPress PHP-FPM is ready."

cd /etc/nginx/certs

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt -subj "/C=MA/ST=NA/L=NA/O=ilazar/OU=42/CN=ilazar.42.fr"

chmod 600 nginx-selfsigned.key

chmod 600 nginx-selfsigned.crt

exec "nginx" "-g" "daemon off;"
