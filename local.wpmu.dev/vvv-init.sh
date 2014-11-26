# Provision WordPress Multisite stable

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_default' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_default"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_default.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-default ]]; then
	mkdir /srv/log/wpmu-default
	touch /srv/log/wpmu-default/error.log
	touch /srv/log/wpmu-default/access.log
fi
# Install and configure the latest stable version of WordPress
if [[ ! -d /srv/www/wpmu-default ]]; then

	mkdir /srv/www/wpmu-default
	cd /srv/www/wpmu-default

	echo "Downloading WordPress Multisite Stable, see http://wordpress.org/"
	wp core download

	echo "Configuring WordPress Multisite Stable..."
	wp core config --dbname=wpmu_default --dbuser=wp --dbpass=wp --quiet --extra-php --allow-root <<PHP
define( 'WP_DEBUG', true );
PHP
	echo "Installing WordPress Multisite Stable..."
	wp core multisite-install --allow-root --url=local.wpmu.dev --subdomains --quiet --title="Local WPMU Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WP MU (2)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site3 --title="WP MU (3)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site4 --title="WP MU (4)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site5 --title="WP MU (5)" --email="admin@local.dev" --quiet --allow-root

else
	echo "Updating WordPress Multisite Stable..."
	cd /srv/www/wpmu-default
	wp core upgrade --allow-root
fi
