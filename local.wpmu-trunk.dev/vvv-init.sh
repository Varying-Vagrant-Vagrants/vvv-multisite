# Provision WordPress trunk via core.svn

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_trunk' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_trunk"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_trunk.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-trunk ]]; then
	mkdir /srv/log/wpmu-trunk
	touch /srv/log/wpmu-trunk/error.log
	touch /srv/log/wpmu-trunk/access.log
fi

# Checkout, install and configure WordPress trunk via core.svn
if [[ ! -d /srv/www/wpmu-trunk ]]; then
	echo "Checking out WordPress trunk from core.svn, see http://core.svn.wordpress.org/trunk"
	svn checkout http://core.svn.wordpress.org/trunk/ /srv/www/wpmu-trunk
	cd /srv/www/wpmu-trunk
	echo "Configuring WordPress Multisite trunk..."
	wp core config --dbname=wpmu_trunk --dbuser=wp --dbpass=wp --quiet --extra-php --allow-root <<PHP
define( 'WP_DEBUG', true );
PHP
	echo "Installing WordPress Multisite trunk..."
	wp core multisite-install --allow-root --url=local.wpmu-trunk.dev --subdomains --quiet --title="Local WPMU Trunk Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WP MU trunk (2)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site3 --title="WP MU trunk (3)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site4 --title="WP MU trunk (4)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site5 --title="WP MU trunk (5)" --email="admin@local.dev" --quiet --allow-root

else
	echo "Updating WordPress Multisite trunk..."
	cd /srv/www/wpmu-trunk
	svn up --ignore-externals
fi
