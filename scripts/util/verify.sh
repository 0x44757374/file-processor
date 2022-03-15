#!/bin/bash
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
RED='\033[0;31m'

proceed=''

while [[ "$proceed" == '' ]]; do
	read -n 1 -p "$1 (y/n): " -s user_confirm
	if [[ "$user_confirm" =~ (y) ]]; then
		proceed='ok'
		echo -e "${GREEN}Proceed${NO_COLOR}"
	fi
	if [[ "$user_confirm" =~ (n) ]]; then
		echo -e "${RED}Skip${NO_COLOR}"
		exit 1
	fi
	if ([[ "$proceed" == '' ]]); then
		echo -e "${RED}Invalid Response '$user_confirm' ${NO_COLOR}"
	fi
done