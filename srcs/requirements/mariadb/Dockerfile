
FROM debian:bullseye-slim

RUN apt-get update -y && apt-get install -y mariadb-server

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/init.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["mariadbd"]
