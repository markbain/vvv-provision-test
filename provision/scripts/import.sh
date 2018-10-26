#!/usr/bin/env bash

# Import existing site or default content

if [[ -d "${archives_files}" ]]; then
	echo -e "\n Importing archive...\n\n"
  unzip "{$archives_files}" -d "${VVV_PATH_TO_SITE}/${WEBROOT}"
fi
if [[ -d "$archives_db" ]]; then
	echo -e "\n Importing database...\n\n"
 	unzip $db -d "${VVV_PATH_TO_SITE}/${WEBROOT}"
 	wp db import db
 	wp search-replace "${old_domain}" "${DOMAIN}" --all-tables
fi
