#!/bin/bash

echo -e "${PURPLE}💥  Setting Up Scripts 💥"
profile=.bashrc
if [[ "$SHELL" == *"zsh"* ]]; then
		echo -e "${CYAN} zsh detected as default shell. Adjusting"
		profile=.zshrc
fi
location=$HOME/$profile
src_dir=$(pwd)

touch $location
chmod u+x $location

# Remove previously existing path, aliases and exports
grep -v 'fpserv=cli.sh' $location > $location.temp && mv $location.temp $location
grep -v 'FILE_PROCESSOR_DIR=' $location > $location.temp && mv $location.temp $location
grep -v "PATH=\$PATH:${PWD}/scripts/sbin/" $location > $location.temp && mv $location.temp $location

# Add cli script, project dir, and alias for cli script to shell profile
echo "export PATH=\$PATH:${PWD}/scripts/sbin/" >> $location
echo "export FILE_PROCESSOR_DIR=${src_dir}" >> $location
echo 'alias fpserv=cli.sh' >> $location

# Source the profile. This will 'error' out for zsh, but that's ok. It should still take effect. 
# Possibly needs to be sourced by user, w/ new shell instance opened
source $location; echo "Shell Profile Set";