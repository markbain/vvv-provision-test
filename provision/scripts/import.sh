#!/usr/bin/env bash

# Import existing site or default content

if [[ ! -d "$archives_files" ]]; then
  unzip $archives_files -d "${VVV_PATH_TO_SITE}/${WEBROOT}"
fi
if [[ ! -d "$archives_db" ]]; then
   unzip $db -d "${VVV_PATH_TO_SITE}/${WEBROOT}"
   wp db import
   wp search-replace "${OLD_DOMAIN}" "${DOMAIN}" --all-tables
fi