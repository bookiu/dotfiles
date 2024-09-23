#!/bin/bash

qssh() {
    local script_dir="$HOME/Projects/ByteDance/quick_jump"
    local alias_file="$HOME/.qssh_aliases"
    local target="$1"

    if [ -f "$alias_file" ]; then
        local alias_target=$(awk -F'=' -v target=$target '$1==target {print $2}' $alias_file)
        if [ -n "$alias_target" ]; then
            target="$alias_target"
        fi
    fi

    local script_name="login_$target.sh"
    local script_path="$script_dir/$script_name"

    if [ -f "$script_path" ]; then
        (
            cd $script_dir
            bash "$script_name"
        )
        return $?
    else
        echo "Error: Script not found. file=$script_name, path=$script_dir"
        return 1
    fi
}

_qssh_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local script_dir="$HOME/Projects/ByteDance/quick_jump"
    local alias_file="$HOME/.qssh_aliases"

    # 获取脚本名称
    local scripts=$(ls "$script_dir"/login_*.sh 2>/dev/null | sed 's/.*login_\(.*\)\.sh/\1/')

    # 获取别名
    local aliases=""
    if [ -f "$alias_file" ]; then
        aliases=$(cut -d'=' -f1 "$alias_file")
    fi

    # 合并脚本名称和别名
    local options="$scripts $aliases"

    COMPREPLY=($(compgen -W "$options" -- "$cur"))
}

complete -F _qssh_completion qssh
