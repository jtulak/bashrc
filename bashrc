# Bash configuration
# Jan Tulak <jan@tulak.me>
# Uses tabstop=4; shiftwidth=4 tabs; foldmarker={{{,}}};
# vim:set syntax=sh:


# Only for interactive shells
#if [ -z "$PS1" ]; then
#   exit
#fi

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='osx'
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Resource files
for file in $HOME/.bash/rc/*.rc; do
	source $file
done


if [[ $platform == "osx" ]]; then
	# Tell the terminal about the working directory at each prompt.
	if [ "$TERM_PROGRAM" == "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
	update_terminal_cwd() {
		# Identify the directory using a "file:" scheme URL,
		# including the host name to disambiguate local vs.
		# remote connections. Percent-escape spaces.
		local SEARCH=' '
		local REPLACE='%20'
		local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
		printf '\e]7;%s\a' "$PWD_URL"
	}
	PROMPT_COMMAND="update_terminal_cwd; $PROMPT_COMMAND"
	fi
fi

PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# source git autocompletion
source ~/.bash/git-completion.bash

# History on partial command
## arrow up
bind '"\e[A":history-search-backward' &>/dev/null
## arrow down
bind '"\e[B":history-search-forward' &>/dev/null

# source the private things that are not synced to git
if [ -f ~/.bash/private.rc ]; then
	source ~/.bash/private.rc
fi
