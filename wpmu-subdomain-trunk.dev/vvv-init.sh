# Provision WordPress Multisite Subdomain trunk via core.svn

# Make a database, if we don't already have one
echo -e "\nCreating database 'wpmu_subdomain_trunk' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wpmu_subdomain_trunk"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wpmu_subdomain_trunk.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
if [[ ! -d /srv/log/wpmu-subdomain-trunk ]]; then
	mkdir /srv/log/wpmu-subdomain-trunk
fi
	touch /srv/log/wpmu-subdomain-trunk/error.log
	touch /srv/log/wpmu-subdomain-trunk/access.log

# Checkout, install and configure WordPress trunk via core.svn
if [[ ! -d /srv/www/wpmu-subdomain-trunk ]]; then

	echo "Checking out WordPress trunk from core.svn, see http://core.svn.wordpress.org/trunk"
	svn checkout http://core.svn.wordpress.org/trunk/ /srv/www/wpmu-subdomain-trunk

	echo "Configuring WordPress Multisite Subdomain Trunk..."
	cd /srv/www/wpmu-subdomain-trunk
	wp core config --dbname=wpmu_subdomain_trunk --dbuser=wp --dbpass=wp --quiet --extra-php --allow-root <<PHP
// Match any requests made via xip.io.
if ( isset( \$_SERVER['HTTP_HOST'] ) && preg_match('/^(wpmu-subdomain-trunk.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(.xip.io)\z/', \$_SERVER['HTTP_HOST'] ) ) {
	define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] );
	define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] );
}

define( 'WP_DEBUG', true );
PHP

	echo "Installing WordPress Multisite Subdomain Trunk..."
	wp core multisite-install --allow-root --url=wpmu-subdomain-trunk.dev --subdomains --quiet --title="WPMU Subdomain Trunk Dev" --admin_name=admin --admin_email="admin@local.dev" --admin_password="password" --allow-root

	# Create sites 2-9
	wp site create --allow-root --slug=site2 --title="WPMU Subdomain Trunk (2)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site3 --title="WPMU Subdomain Trunk (3)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site4 --title="WPMU Subdomain Trunk (4)" --email="admin@local.dev" --quiet --allow-root
	wp site create --allow-root --slug=site5 --title="WPMU Subdomain Trunk (5)" --email="admin@local.dev" --quiet --allow-root

else

	echo "Updating WordPress Multisite Subdomain Trunk..."
	cd /srv/www/wpmu-subdomain-trunk
	svn up

fi
