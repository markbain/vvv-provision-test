#!/usr/bin/env bash

source "vvv-vars"

echo -e "\n-----------------------------\n\n"

source "${scripts_dir}/webroot.sh"

# Configure WP-CLI
echo -e "\nCreating or updating 'wp-cli.yml'"
cp -f "${VVV_PATH_TO_SITE}/wp-cli.yml.tmpl" "${VVV_PATH_TO_SITE}/wp-cli.yml"
sed -i "s#{{WEBROOT_HERE}}#${WEBROOT}#" "${VVV_PATH_TO_SITE}/wp-cli.yml"



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
  noroot wp core update --version="${WP_VERSION}" --path="${VVV_PATH_TO_SITE}/${WEBROOT}"
fi

source "${scripts_dir}/nginx.sh"
source "${scripts_dir}/ssl.sh"
source "${scripts_dir}/create_dirs.sh"
# source "${scripts_dir}/import.sh"
# source "${scripts_dir}/replace.sh"

# Run NPM init if there's a package.json
# source "${scripts_dir}/npm.sh"
