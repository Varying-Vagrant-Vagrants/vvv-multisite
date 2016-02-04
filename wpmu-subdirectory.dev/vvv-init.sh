# Provision WordPress Multisite stable

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_subdirectory' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_subdirectory"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_subdirectory.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-subdirectory ]]; then
	mkdir /srv/log/wpmu-subdirectory
fi
	touch /srv/log/wpmu-subdirectory/error.log
	touch /srv/log/wpmu-subdirectory/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -d /srv/www/wpmu-subdirectory ]]; then

	mkdir /srv/www/wpmu-subdirectory
	cd /srv/www/wpmu-subdirectory

	echo "Downloading WordPress Multisite Subdirectory Stable, see http://wordpress.org/"
	wp core download --allow-root

	echo "Configuring WordPress Multisite Subdirectory Stable..."
	wp core config --dbname=wpmu_subdirectory --dbuser=wp --dbpass=wp --extra-php --allow-root <<PHP
// Match any requests made via xip.io.
if ( isset( \$_SERVER['HTTP_HOST'] ) && preg_match('/^(wpmu-subdirectory.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(.xip.io)\z/', \$_SERVER['HTTP_HOST'] ) ) {
	define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] );
	define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] );
}

define( 'WP_DEBUG', true );
PHP
	echo "Installing WordPress Multisite Subdirectory Stable..."
	wp core multisite-install --allow-root --url=wpmu-subdirectory.dev --title="WPMU Subdirectory Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WPMU Subdirectory (2)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site3 --title="WPMU Subdirectory (3)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site4 --title="WPMU Subdirectory (4)" --email="admin@local.dev" --allow-root
	wp site create --allow-root --slug=site5 --title="WPMU Subdirectory (5)" --email="admin@local.dev" --allow-root

else

	echo "Updating WordPress Multisite Subdirectory Stable..."
	cd /srv/www/wpmu-subdirectory
	wp core upgrade --allow-root

fi
