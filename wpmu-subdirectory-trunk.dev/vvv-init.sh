# Provision WordPress Multisite Subdirectory trunk via core.svn

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_subdirectory_trunk' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_subdirectory_trunk"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_subdirectory_trunk.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-subdirectory-trunk ]]; then
	mkdir /srv/log/wpmu-subdirectory-trunk
fi
	touch /srv/log/wpmu-subdirectory-trunk/error.log
	touch /srv/log/wpmu-subdirectory-trunk/access.log

# Checkout, install and configure WordPress trunk via core.svn
if [[ ! -d /srv/www/wpmu-subdirectory-trunk ]]; then

	echo "Checking out WordPress trunk from core.svn, see http://core.svn.wordpress.org/trunk"
	svn checkout http://core.svn.wordpress.org/trunk/ /srv/www/wpmu-subdirectory-trunk

	echo "Configuring WordPress Multisite Subdirectory Trunk..."
	cd /srv/www/wpmu-subdirectory-trunk
	wp core config --dbname=wpmu_subdirectory_trunk --dbuser=wp --dbpass=wp --quiet --extra-php --allow-root <<PHP
define( 'WP_DEBUG', true );
PHP
	echo "Installing WordPress Multisite Subdirectory Trunk..."
	wp core multisite-install --allow-root --url=wpmu-subdirectory-trunk.dev --quiet --title="Local WPMU Subdirectory Trunk Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WP MU (2)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site3 --title="WP MU (3)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site4 --title="WP MU (4)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site5 --title="WP MU (5)" --email="admin@local.dev" --quiet --allow-root

else

	echo "Updating WordPress Multisite Subdirectory Trunk..."
	cd /srv/www/wpmu-subdirectory-trunk
	svn up

fi
