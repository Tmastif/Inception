#!/bin/bash
set -e

# Directory where MariaDB stores data
DATADIR="/var/lib/mysql"

# If data directory is empty or uninitialized, initialize DB
if [ ! -d "$DATADIR/mysql" ]; then
  echo "Initializing database..."

  # Initialize MariaDB data directory (equivalent to mysql_install_db)
  mysql_install_db --user=mysql --datadir="$DATADIR" --basedir=/usr --rpm

  echo "Database initialized."

  # Start MariaDB server in the background temporarily
  mysqld_safe --datadir="$DATADIR" &
  
  # Wait for MariaDB to start up
  echo "Waiting for MariaDB to start..."
  until mysqladmin ping --silent; do
    sleep 1
  done

  echo "MariaDB started."

  # Set root password and create initial users/databases
  mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}'; FLUSH PRIVILEGES;"

  # Optionally create your database and user here
  mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
  mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
  mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
  mysql -e "FLUSH PRIVILEGES;"

  # Stop the temporary MariaDB server before starting the final one
  mysqladmin shutdown

  echo "Initialization complete."
fi

# Finally, start MariaDB in the foreground (so container stays alive)
exec "$@"