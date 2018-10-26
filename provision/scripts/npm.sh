#!/usr/bin/env bash

# NPM

echo -e "\nLooking for package.json...\n\n"
echo -e "\n...\n\n"
echo -e "\n...\n\n"

if [[ -f "${VVV_PATH_TO_SITE}/package.json" ]]; then
	echo -e "\npackage.json found!\n\n"
	echo -e "\n...\n\n"
	echo -e "\n...\n\n"
  npm install

else 
	echo -e "\npackage.json not found. Not using NPM, huh?\n\n"
fi
