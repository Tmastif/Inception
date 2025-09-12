# Use the Debian Bullseye Slim image
FROM debian:bullseye-slim

# Install MariaDB server and client, and clean up apt cache
RUN apt-get update && apt-get install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*

# Create the MariaDB socket directory and set ownership and permissions
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# Copy configuration files and initialization script
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# Copy your custom entrypoint script and make it executable
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expose the standard MariaDB port
EXPOSE 3306

# Use your custom script as the entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# The command to be executed by your entrypoint
CMD ["mysqld_safe", "--datadir=/var/lib/mysql"]
