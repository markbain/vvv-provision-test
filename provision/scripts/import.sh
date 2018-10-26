#!/usr/bin/env bash

# Import existing site or default content

echo -e "\nChecking for existing site to import...\n\n"
echo -e "\n...\n\n"
echo -e "\n...\n\n"

if [[ -f "${archive_files}" ]]; then
	echo -e "\n Archive found! Importing archive...\n\n"
	echo -e "\n...\n\n"
	echo -e "\n...\n\n"
  unzip "{$archive_files}" -d "${VVV_PATH_TO_SITE}/${WEBROOT}"

else 
	echo -e "\nNo files found to import\n\n"
fi
if [[ -f "$archive_db" ]]; then
	echo -e "\n Database found! Importing database...\n\n"
	echo -e "\n...\n\n"
	echo -e "\n...\n\n"
 	unzip "{$archive_db}" -d "${VVV_PATH_TO_SITE}/${WEBROOT}"
 	wp db import db
 	wp search-replace "${old_domain}" "${DOMAIN}" --all-tables
else 
	echo -e "\nNo database found to import\n\n"
fi
