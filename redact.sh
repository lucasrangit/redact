#!/usr/bin/env bash
set -o errexit
#set -o xtrace

usage() {
	echo "Usage: $0 [-i] [-q] filename"
	echo -e "\t-v: Verbose output"
}

while getopts ":v" opt; do
	case $opt in
		v)
			do_verbose=true
			;;
    		\?)
			usage
			exit 1
			;;
	esac
done

shift $(($OPTIND - 1))
if [[ ! -n "$1" ]]; then
	usage
	exit 1
fi

_file=$1

_redact() {
	if [[ $do_verbose ]]; then
		echo "$1 -> $2"
	fi
	sed -i "s|$1|$2|g" "$_file"
}

# NIB: Order matters! For example, USERNAME is present in HOME so it should be redacted last.
_redact $HOME "/home/user"
_redact $HOSTNAME "localhost"
_redact $USER "user"

for i in $(hostname -I); do
	_redact $i "127.0.0.1"
done

exit 0

