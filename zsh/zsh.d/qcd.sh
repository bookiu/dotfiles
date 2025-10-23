#!/bin/bash

qcd() {
	case "$1" in
	home)
		cd $HOME
		;;
	*)
		echo "qcd: unkown key '$1'"
		return 1
		;;
	esac
	pwd
}

if which complete &>/dev/null; then
    complete -W "home" qcd
fi
