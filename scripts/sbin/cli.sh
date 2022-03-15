#!/bin/bash
cd $FILE_PROCESSOR_DIR
scripts=$PWD/scripts

export $(cat .env | xargs)
NOCOLOR='\033[0;0m'
BOLD='\033[0;1m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
ERROR='\033[1;31m'

NEEDS_MORE_ARGS="${ERROR}Error: fpserv requires at least 1 command${NOCOLOR}"
USAGE="${CYAN}fpserv ${NOCOLOR}[${GREEN}command${NOCOLOR}] ${NOCOLOR}[${PURPLE}...args${NOCOLOR}]"
GET_HELP="For Help: ${CYAN}fpserv ${NOCOLOR}[${GREEN}help${NOCOLOR}]${NOCOLOR}"
if [ $# -lt 1 ] 
then
	echo -e  "$NEEDS_MORE_ARGS\n$USAGE\n$GET_HELP" ; exit 1;
fi

COMMANDS=(
	"${BOLD}Build Image:${NOCOLOR}"
	"${GREEN}[build]${PURPLE} [target1, target2, ...]${NOCOLOR}"
	"${BOLD}Start Container:${NOCOLOR}"
	"${GREEN}[start]${PURPLE} [target1, target2, ...]${NOCOLOR}"
	"${BOLD}Stop/Kill Container:${NOCOLOR}"
	"${GREEN}[stop]${PURPLE} [target1, target2, ...]${NOCOLOR}"
	"${BOLD}Print Logs (Container):${NOCOLOR}"
	"${GREEN}[logs]${PURPLE} [target1, target2, ...]${NOCOLOR}"
	"${BOLD}Environment Variable Setup:${NOCOLOR}"
	"${GREEN}[env]${PURPLE}${NOCOLOR}"
	"${BOLD}Show Container Status:${NOCOLOR}"
	"${GREEN}[status]${PURPLE}${NOCOLOR}"
	"${BOLD}Show Help Menu & Commands:${NOCOLOR}"
	"${GREEN}[help]${PURPLE}${NOCOLOR}"
)

command=${@:1:1}
rest=${@:2}

case $command in

	build )
		if [ $# -lt 2 ]; then
			echo -e "${CYAN}Building ${PROJECT_NAME}${NOCOLOR}"
			docker compose build
		else
			for target in "${@:2}" 
			do
				echo -e "${CYAN}Building ${PURPLE}$target${NOCOLOR}"
				docker compose build "$target"
			done
		fi
	;;

	logs )
		for target in "${@:2}" 
		do
			echo -e "${CYAN}🪵  Start of Logs for ${PURPLE}${target} 🪵${NOCOLOR}"
			docker logs "${PROJECT_NAME}-$target"
			echo -e "${CYAN}🪵  End of Logs for ${PURPLE}${target} 🪵${NOCOLOR}"
		done
	;;

	start )
		if [ $# -lt 2 ]; then
			echo -e "${CYAN}Starting ${PROJECT_NAME}${NOCOLOR}"
			docker compose up
		else
			for target in "${@:2}" 
			do
				echo -e "${CYAN}Starting ${PURPLE}$target${NOCOLOR}"
				docker compose up "$target"
			done
		fi
	;;

	stop )
		if [ $# -lt 2 ]; then
			echo -e "${CYAN}Stopping ${PROJECT_NAME}${NOCOLOR}"
			docker compose down
		else
			for target in "${@:2}" 
			do
				echo -e "${CYAN}Stopping ${PURPLE}$target${NOCOLOR}"
				docker compose down "$target"
			done
		fi
	;;

	env )
		./scripts/util/env.sh
	;;

	status )
		./scripts/util/container-status.sh
	;;

	help | h | -h | --h | --help | -help | commands)
		commands=""
		for item in "${COMMANDS[@]}"
		do
			commands="$commands$item\n"
		done
		echo -e "$USAGE\n\n${commands}"; exit 1;
	;;

	* )
		echo -e  "$USAGE\n$GET_HELP" ; exit 1;
	;;

esac

