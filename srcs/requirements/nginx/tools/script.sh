#!/bin/bash

cd /etc/nginx/certs

# Generate private key
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout nginx-selfsigned.key -out nginx-selfsigned.crt -subj "/C=MA/ST=NA/L=NA/O=ilazar/OU=42/CN=ilazar.42.fr"

# Secure the private key
chmod 600 nginx-selfsigned.key
chmod 600 nginx-selfsigned.crt

# Run nginx in the foreground
exec "nginx" "-g" "daemon off;"
