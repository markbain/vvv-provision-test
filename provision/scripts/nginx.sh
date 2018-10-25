#!/usr/bin/env bash

# Nginx
cp -f "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf.tmpl" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{DOMAINS_HERE}}#${DOMAINS}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"
sed -i "s#{{WEBROOT_HERE}}#${WEBROOT}#" "${VVV_PATH_TO_SITE}/provision/vvv-nginx.conf"