# zsh completions for 'mydb'

local mydb_config_file=${MYDB_CONFIG_FILE:-$HOME/.config/mydb/config.json}

_mydb() {
    #tmp=($(sed -n '/\[alias_dsn\]/,/^\w+/p;' $HOME/.myclirc | grep -E '^\w+' | awk -F '[= ]' '{print $1}'))
    compadd -- $(jq -r 'keys[]' $mydb_config_file) 2>/dev/null
}
compdef _mydb mysql mycli

_jq_expr() {
    name=$2
    t=$1

    expression='"'
    if [[ "$t" == "mysql" ]]; then
        expression="${expression}--default-character-set="
    else
        expression="${expression}--charset="
    fi
    expression="${expression}\(.[\"$name\"].charset) -h\(.[\"$name\"].host) -P\(.[\"$name\"].port)"
    expression="${expression} -u\(.[\"$name\"].user) -p\(.[\"$name\"].password) "
    expression="${expression} \(.[\"$name\"].database)\""
    echo $expression
}

mysql_bin=$(which mysql)
mysql() {
    if [ $# -eq 0 ]; then
        command mysql
        return
    fi
    expression=$(_jq_expr 'mysql' $1)
    local arguments=$(jq -r $expression $mydb_config_file)
    cmd="$mysql_bin $arguments"
    echo "$cmd" | sed -E 's#-p.*? #-pxxxxxx #'
    eval $cmd
}

mycli_bin="~/.pyenv/shims/mycli"
mycli() {
    if [ $# -eq 0 ]; then
        command mycli
        return
    fi
    expression=$(_jq_expr 'mycli' $1)
    local arguments=$(jq -r $expression $mydb_config_file)
    cmd="$mycli_bin $arguments"
    echo "$cmd" | sed -E 's#-p.*? #-pxxxxxx #'
    eval $cmd
}
