#!/bin/bash
cd ..
NO_COLOR='\033[0;0m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'

VERIFY_SCRIPT='./scripts/util/verify.sh'
verify () { $VERIFY_SCRIPT "$1" || { return 1; }; }
print_stage_start () { echo -e "${NO_COLOR}Stage ${PURPLE}[${1}/${STAGE_COUNT}]${CYAN}: ${2}"; }
print_stage_complete () { echo -e "${NO_COLOR}Stage ${PURPLE}[${1}/${STAGE_COUNT}]${GREEN}: Complete ✅"; }

script_permissions_stage () {
	print_stage_start $1 "Adding User Execute Permissions to Init Scripts";
	find ./scripts -iname "*.sh" -exec chmod u+x '{}' \; || exit 1;
}

deps_stage () {
	print_stage_start $1 "Installing Dependencies"
	if verify "Install Dependencies"; then
		./scripts/util/deps.sh
		else
		{ echo -e "${YELLOW}User Skipped${NOCOLOR}"; }
	fi
}

cli_stage () {
	print_stage_start $1 "Adding CLI to Path";
	if verify "Add CLI To Path (as 'fpserv <command> <args>')"; then
		./scripts/util/path.sh
		else
		{ echo -e "${YELLOW}User Skipped${NOCOLOR}"; }
	fi
}

env_stage () {
	print_stage_start $1 "Creating Environment Variables File"
	./scripts/util/env.sh
}

test_stage () {
	print_stage_start $1 "Test Stage"
}

STAGES=( 
	script_permissions_stage 
	env_stage
	deps_stage
	cli_stage
)

STAGE_COUNT=${#STAGES[@]};

echo -e "${CYAN}💥  Initializing File Processor Server 💥"

for i in ${!STAGES[@]}; do
	stage=$((i+1))
	${STAGES[$i]} $stage;
	print_stage_complete $((i+1))
done

echo -e "${CYAN}🏁 File Processor Server Initialized 🏁${NOCOLOR}"
echo -e "${GREEN}Exit, and start a new shell instance for changes to take effect.${NOCOLOR}"