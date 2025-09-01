#!/bin/bash
set -e

# This script is designed to run only the first time the container starts.
# It checks if the database directory already exists.
if [ ! -d "/var/lib/mysql/${DB_DATABASE}" ]; then
    echo "Inception: ${DB_DATABASE} database is being created."
    
    # Start the MariaDB service in the background
    service mariadb start

    # Create the database, user, and grant privileges
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${DB_DATABASE}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON \`${DB_DATABASE}\`.* TO '${DB_USER}'@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
    
    # Shut down the temporary MariaDB service
    mariadb-admin shutdown
    echo "Inception: ${DB_DATABASE} database and user created successfully."
else
    echo "Inception: ${DB_DATABASE} database is already there.";
fi

# Start the MariaDB service in a safe mode for the main process
exec "$@"