FROM alpine:3.22

RUN apk add --no-cache php82-fpm php82-common php82-cli php82-ctype \
    php82-curl php82-dom php82-exif php82-fileinfo php82-gd php82-iconv \
    php82-json php82-mbstring php82-mysqli php82-openssl php82-pdo \
    php82-pdo_mysql php82-session php82-tokenizer php82-xml php82-xmlreader \
    php82-zlib php82-zip php82-opcache php82-pecl-imagick \
    curl tar dos2unix php82-phar mariadb-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php82/php-fpm.d/www.conf
COPY ./conf/php.ini /etc/php82/php.ini
COPY ./tools/script.sh /script.sh

RUN dos2unix /script.sh
RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]

