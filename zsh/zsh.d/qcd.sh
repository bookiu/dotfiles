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

complete -W "home" qcd
