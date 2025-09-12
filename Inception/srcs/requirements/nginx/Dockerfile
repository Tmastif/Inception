FROM debian:bullseye

RUN apt-get update && apt-get install nginx openssl netcat -y

RUN mkdir -p /etc/nginx/certs

COPY ./conf/default /etc/nginx/sites-available/

COPY ./tools/script.sh /etc/nginx/certs

RUN chmod +x /etc/nginx/certs/script.sh

CMD ["/etc/nginx/certs/script.sh"]

