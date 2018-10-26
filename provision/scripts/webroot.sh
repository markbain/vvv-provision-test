#!/usr/bin/env bash

# Define webroot
echo -e "\nDefining webroot for ${VVV_SITE_NAME}..."
if [[ -f "/vagrant/www/custom-configs/${VVV_SITE_NAME}/${VVV_SITE_NAME}.conf" ]]; then
  source "/vagrant/www/custom-configs/${VVV_SITE_NAME}/${VVV_SITE_NAME}.conf"
else
	echo -e "\nNo custom webroot found in /vagrant/www/custom-configs/${VVV_SITE_NAME}/${VVV_SITE_NAME}.conf"
  WEBROOT="public_html"
fi
