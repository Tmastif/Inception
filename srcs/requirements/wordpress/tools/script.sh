#!/bin/sh

echo "Waiting for MariaDB to be fully ready..."
# The `until` loop checks for both a network connection and successful authentication.
until /usr/bin/mariadb-admin ping -h "$DB_HOST" -u "root" -p"$DB_ROOT_PASSWORD" --silent && nc -z "$DB_HOST" 3306; do
    echo "MariaDB is not yet ready. Waiting..."
    sleep 2
done
echo "MariaDB is ready."

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    
    # Download and configure WordPress core using wp-cli
    wp core download --allow-root
    wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}" --allow-root
    wp core install --url="https://${DOMAIN_NAME}" --title="${WP_SITE_TITLE}" --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_EMAIL}" --allow-root
fi

echo "Starting php-fpm..."
exec /usr/sbin/php-fpm82 -F