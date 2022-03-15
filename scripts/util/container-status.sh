#!/bin/bash
NOCOLOR='\033[0;0m'
BOLD='\033[0;1m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
ERROR='\033[1;31m'

status=$(docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Size}}\t{{.Networks}}")
table_head="$(echo "$status" | sed '1q')"
echo -e "${PURPLE}$table_head${NOCOLOR}"
project_matches="$(echo "$status" | grep ${PROJECT_NAME})"
echo -e "${GREEN}$(echo "$project_matches" | grep " Up ")${NOCOLOR}\
${YELLOW}$(echo "$project_matches" | grep " Restarting ")${NOCOLOR}\
${YELLOW}$(echo "$project_matches" | grep " Created ")${NOCOLOR}\
${RED}$(echo "$project_matches" | grep " Exited ")${NOCOLOR}"
