# Provision WordPress Multisite stable

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_subdomain' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_subdomain"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_subdomain.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-subdomain ]]; then
	mkdir /srv/log/wpmu-subdomain
fi
	touch /srv/log/wpmu-subdomain/error.log
	touch /srv/log/wpmu-subdomain/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d /srv/www/wpmu-subdomain ]]; then

	mkdir /srv/www/wpmu-subdomain
	cd /srv/www/wpmu-subdomain

	echo "Downloading WordPress Multisite Subdomain Stable, see http://wordpress.org/"
	wp core download --allow-root

	echo "Configuring WordPress Multisite Subdomain Stable..."
	wp core config --dbname=wpmu_subdomain --dbuser=wp --dbpass=wp --extra-php --allow-root <<PHP
// Match any requests made via xip.io.
if ( isset( \$_SERVER['HTTP_HOST'] ) && preg_match('/^(wpmu-subdomain.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(.xip.io)\z/', \$_SERVER['HTTP_HOST'] ) ) {
	define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] );
	define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] );
}

define( 'WP_DEBUG', true );
PHP
	echo "Installing WordPress Multisite Subdomain Stable..."
	wp core multisite-install --allow-root --url=wpmu-subdomain.dev --subdomains --title="WPMU Subdomain Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WPMU Subdomain (2)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site3 --title="WPMU Subdomain (3)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site4 --title="WPMU Subdomain (4)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site5 --title="WPMU Subdomain (5)" --email="admin@local.dev" --allow-root

else

	echo "Updating WordPress Multisite Subdomain Stable..."
	cd /srv/www/wpmu-subdomain
	wp core upgrade --allow-root

fi
