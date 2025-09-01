#!/bin/bash
set -e

mysqld_safe --datadir=/var/lib/mysql &

# Wait for the MariaDB service to become available
# This ensures WordPress (or the init script) doesn't run SQL commands before MariaDB is ready
until mysqladmin ping -h mariadb -u $DB_USER -p$DB_PASSWORD --silent; do
  echo "Waiting for MariaDB with $DB_USER/$DB_PASSWORD..."
  sleep 2
done

# Setup: Create the WordPress database (if it doesn't already exist)
# Fulfills requirement to auto-configure MariaDB without manual steps
mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# Create the WordPress DB user if it doesn't exist yet
# Avoids hardcoding credentials — uses environment variables from .env
mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"

# Grant full permissions on the DB to the new user (WordPress requires full access)
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"

# Reload privileges immediately
mysql -u root -e "FLUSH PRIVILEGES;"


# Keep the MariaDB server running in the foreground
# Prevents container from exiting immediately after script runs
wait