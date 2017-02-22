#/usr/bin/env bash
# Jan Tulak <jan@tulak.me>
# Licensed under BSD license
#
# expects output of:
# git log --pretty=format:'%h%d %s [%an]' --decorate --all --graph --color=always
#
# I suggest piping it into "less -RXFS"
#
awk '
BEGIN{
	hashRe="[a-f0-9]{7,10}"
	authorRe="\\[[^\\]]+\\]$"
	refRe="^ ?\\([^\\)]+\\)"
}
{
	graph	=""
	hash	=""
	ref	=""
	subj	=""
	author	=""
	tail	=$0

	# find the hash - the first such string
	# (if nothing found, it is one of the graph lines, so just print it)
	if( match(tail, hashRe)) {
		graph = substr(tail, 0, RSTART-1)
		hash = substr(tail, RSTART, RLENGTH)
		tail = substr(tail, RSTART+RLENGTH)

		match(tail, authorRe)
		author = substr(tail, RSTART, RLENGTH)
		subj = substr(tail, 0, RSTART-1)

		# get ref part of subject
		if(match(subj, refRe)) {
			ref = substr(subj, 0, RLENGTH)
			subj = substr(subj, RLENGTH+1)
		}

		# OK, now we have split the log into parts.
		# Lets look closer on some of them.
	
		# color the ref
		if (ref != "") {
			rHead = ""
			refColor = ""
			# for each part of ref
			split(substr(ref, 3, length(ref)-3), refs, ", ")
			for (i=0; i<length(refs); i++) {
				if (i > 1) {
					refColor = refColor ", "
				}

				str = refs[i]
				if(match(str, "^HEAD($| -> )")) {
					# bold white HEAD
					str = "\033[1;37m" str "\033[0;33m"
				} else if (match(str, "^tag: .+")) {
					# bold yellow tags
					str = "\033[1;33m" str "\033[0;33m"
				} else if (match(str, "\\<[^/,]+/[^/,]+\\>")){
					# bold red remote branches
					str = "\033[1;31m" str "\033[0;33m"
				} else {
					# bold green local branches
					str = "\033[1;32m" str "\033[0;33m"
				}

				refColor = refColor str
			}

			ref = " \033[0;33m(" refColor "\033[0;33m)"
		}
	} else {
		graph=tail
	}
	print graph "\033[0;33m" hash ref "\033[0m" subj "\033[0;34m" author "\033[0m"
}
'
