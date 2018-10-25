#!/usr/bin/env bash
# Provision WordPress Stable

# Intro 
echo -e "\nWelcome to Bain Design VVV Provisioning!"

if [[ ! -f "${VVV_PATH_TO_SITE}/provision/custom-provision.conf" ]]; then
  cp -f "${VVV_PATH_TO_SITE}/provision/custom-provision.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/custom-provision.conf"
  echo -e "\nEnter the webroot (e.g. htdocs), followed by [ENTER]:"
  read -p path
  sed -i "s#{{WEBROOT_HERE}}#${path}#" "${VVV_PATH_TO_SITE}/provision/custom-provision.conf"
fi

source "${VVV_PATH_TO_SITE}/provision/custom-provision.conf"

# Configure WP-CLI
echo -e "\nCreating or updating 'wp-cli.yml'"
cp -f "${VVV_PATH_TO_SITE}/wp-cli.yml.tmpl" "${VVV_PATH_TO_SITE}/wp-cli.yml"
sed -i "s#{{WEBROOT_HERE}}#${WEBROOT}#" "${VVV_PATH_TO_SITE}/wp-cli.yml"

DOMAIN=`get_primary_host "${VVV_SITE_NAME}".test`
DOMAINS=`get_hosts "${DOMAIN}"`
SITE_TITLE=`get_config_value 'site_title' "${DOMAIN}"`
WP_VERSION=`get_config_value 'wp_version' 'latest'`
WP_TYPE=`get_config_value 'wp_type' "single"`
DB_NAME=`get_config_value 'db_name' "${VVV_SITE_NAME}"`
DB_NAME=${DB_NAME//[\\\/\.\<\>\:\"\'\|\?\!\*-]/}

# Make a database, if we don't already have one
echo -e "\nCreating database '${DB_NAME}' (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME}"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO wp@localhost IDENTIFIED BY 'wp';"
echo -e "\n DB operations done.\n\n"

# Nginx Logs
mkdir -p ${VVV_PATH_TO_SITE}/log
touch ${VVV_PATH_TO_SITE}/log/error.log
touch ${VVV_PATH_TO_SITE}/log/access.log

# Install and configure the latest stable version of WordPress
if [[ ! -f "${VVV_PATH_TO_SITE}/${WEBROOT}/wp-load.php" ]]; then
    echo "Downloading WordPress..."
	noroot wp core download --version="${WP_VERSION}"
fi

if [[ ! -f "${VVV_PATH_TO_SITE}/${WEBROOT}/wp-config.php" ]]; then
  echo "Configuring WordPress Stable..."
  noroot wp core config --dbname="${DB_NAME}" --dbuser=wp --dbpass=wp --quiet --extra-php <<PHP
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
PHP
fi

if ! $(noroot wp core is-installed); then
  echo "Installing WordPress Stable..."

  if [ "${WP_TYPE}" = "subdomain" ]; then
    INSTALL_COMMAND="multisite-install --subdomains"
  elif [ "${WP_TYPE}" = "subdirectory" ]; then
    INSTALL_COMMAND="multisite-install"
  else
    INSTALL_COMMAND="install"
  fi

  noroot wp core ${INSTALL_COMMAND} --url="${DOMAIN}" --quiet --title="${SITE_TITLE}" --admin_name=admin --admin_email="admin@local.test" --admin_password="password"
else
  echo "Updating WordPress Stable..."
  cd ${VVV_PATH_TO_SITE}/${WEBROOT}
  noroot wp core update --version="${WP_VERSION}"
fi

# Create some directories
if [[ ! -d "${VVV_PATH_TO_SITE}/import" ]]; then
    echo "Creating Import directory..."
    mkdir -p import
fi
if [[ ! -d "${VVV_PATH_TO_SITE}/export" ]]; then
    echo "Creating Export directory..."
    mkdir -p export
fi
if [[ ! -d "${VVV_PATH_TO_SITE}/release" ]]; then
    echo "Creating Release directory..."
    mkdir -p release
fi

cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{WEBROOT_HERE}}#${WEBROOT}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"

# SSL
if [ -n "$(type -t is_utility_installed)" ] && [ "$(type -t is_utility_installed)" = function ] && `is_utility_installed core tls-ca`; then
    sed -i "s#{{TLS_CERT}}#ssl_certificate /vagrant/certificates/${VVV_SITE_NAME}/dev.crt;#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
    sed -i "s#{{TLS_KEY}}#ssl_certificate_key /vagrant/certificates/${VVV_SITE_NAME}/dev.key;#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
else
    sed -i "s#{{TLS_CERT}}##" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
    sed -i "s#{{TLS_KEY}}##" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
fi
