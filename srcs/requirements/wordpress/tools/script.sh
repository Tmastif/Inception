#!/bin/sh

echo "Waiting for MariaDB to be fully ready..."
until mariadb -h mariadb -u "$DB_USER" -p"$DB_PASSWORD" --ssl=0 -e "SELECT 1" &>/dev/null; do
    echo "MariaDB is not yet ready. Waiting..."
    sleep 2
done
echo "MariaDB is ready."

cd /var/www/html || exit 1  # Fail early if cd fails

if ! /usr/bin/php82 /usr/local/bin/wp core is-installed --allow-root &>/dev/null; then
    echo "Installing WordPress..."

    # Download and configure WordPress core using wp-cli
    /usr/bin/php82 /usr/local/bin/wp core download --allow-root
    /usr/bin/php82 /usr/local/bin/wp config create \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${DB_HOST}" \
        --allow-root

    /usr/bin/php82 /usr/local/bin/wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_SITE_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_EMAIL}" \
        --skip-email \
        --allow-root

    #echo "Setting necessary wp-config.php values..."
    #/usr/bin/php82 /usr/local/bin/wp config set MYSQL_CLIENT_FLAGS 0 --allow-root &>/dev/null
    #/usr/bin/php82 /usr/local/bin/wp config set WP_HOME "https://${DOMAIN_NAME}" --allow-root &>/dev/null
    #/usr/bin/php82 /usr/local/bin/wp config set WP_SITEURL "https://${DOMAIN_NAME}" --allow-root &>/dev/null

else
    echo "WordPress is already installed."
fi

echo "Starting php-fpm."
exec /usr/sbin/php-fpm82 -F


