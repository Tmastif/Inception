#!/bin/sh

#echo "Waiting for MariaDB to be fully ready..."
# The `until` loop checks for both a network connection and successful authentication.
#until /usr/bin/mariadb-admin ping -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" --silent; do
#    echo "MariaDB is not yet ready. Waiting..."
#    sleep 2
#done
#echo "MariaDB is ready."

if ! /usr/bin/php82 /usr/local/bin/wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    
    # Download and configure WordPress core using wp-cli
    /usr/bin/php82 /usr/local/bin/wp core download --allow-root
    /usr/bin/php82 /usr/local/bin/wp config create --dbname="${DB_NAME}" --dbuser="${DB_USER}" --dbpass="${DB_PASSWORD}" --dbhost="${DB_HOST}" --allow-root
    /usr/bin/php82 /usr/local/bin/wp core install --url="https://${DOMAIN_NAME}" --title="${WP_SITE_TITLE}" --admin_user="${WP_ADMIN_USER}" --admin_password="${WP_ADMIN_PASSWORD}" --admin_email="${WP_EMAIL}" --skip-email --allow-root
else
    echo "WordPress is already installed."
fi

echo "Starting php-fpm."
exec /usr/sbin/php-fpm82 -F