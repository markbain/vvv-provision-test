#!/usr/bin/env bash

# Define webroot
if [[ ! -f "/vagrant/www/custom-configs/${VVV_SITE_NAME}/${VVV_SITE_NAME}.conf" ]]; then
  source "/vagrant/www/custom-configs/${VVV_SITE_NAME}/${VVV_SITE_NAME}.conf"
else
  WEBROOT="public_html"
fi
